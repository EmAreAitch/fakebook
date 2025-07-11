class GenerateBotJob < ApplicationJob
  queue_as :default

  before_enqueue do |job|
    bot_request = job.arguments.first
    throw :abort if bot_request.bot_id?
  end

  def perform(bot_request)
    interest_names = bot_request.tags
    normalized_tags = interest_names.map { |it| { name: it } }

    # Generate only the bot and profile data
    bot_data = BotGenerator.generate_bot_for(interest_names)
    generated_bot = Bot.new(bot_data["bot"])
    profile = Profile.new(bot_data["profile"].merge(user: generated_bot))

    # Update the bot request with the new bot
    bot_request.bot = generated_bot

    # Wrap save operations in a transaction
    ActiveRecord::Base.transaction do
      generated_bot.save!    # Saves the bot and raises an error if invalid
      profile.save!          # Save associated profile; uses the bot that was just saved
      bot_request.save!

      # Build and save interest relations for the bot
      relations = build_interest_relations(normalized_tags, interest_names, generated_bot)
      InterestRelation.insert_all!(relations, returning: false) unless relations.empty?
    end  
  end

  private

  def validate_interests!(interests)
    interests = interests.map { Interest.new(name: it.to_s.upcase.strip) }
    interests.all?(&:validate!)
  end

  def build_interest_relations(normalized_tags, interest_names, bot)
    combined_names = interest_names.uniq.map { |name| name.to_s.upcase.strip }
    validate_interests!(combined_names)
    # Insert all tags
    Interest.insert_all(normalized_tags, returning: false)

    # Get the interests
    interests = Interest.where(name: combined_names)

    # Create bot relations with interests
    bot_rel = interest_names.each_with_object({}) do |name, hash|
      hash[name.to_s.upcase.strip] = {
        interestable_type: "User",
        interestable_id: bot.id,
        weight: 0.5
      }
    end

    # Build the final relations array
    interests.each_with_object([]) do |interest, relations|
      n = interest.name
      relations << bot_rel[n].merge(interest_id: interest.id) if bot_rel[n]
    end
  end
end
