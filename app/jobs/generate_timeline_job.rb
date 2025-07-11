class GenerateTimelineJob < ApplicationJob
  queue_as :default

  def perform(bot)
    interests = bot.interests.pluck(:name)
    topics = TopicListGenerator.generate_topics_for(interests).reverse
    post_timeline = bot.post_timeline || bot.build_post_timeline
    post_timeline.assign_attributes(topics:, counter: topics.length)
    post_timeline.save!  
  end
end
