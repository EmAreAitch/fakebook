class ExtractTagsJob < ApplicationJob
  queue_as :default

  def perform(post)
    tags = InterestTagsExtractor.extract_tags_from(post.content)
    relations = build_interest_relations(post, tags)
    InterestRelation.insert_all!(relations) unless relations.empty?
  end

  private

  def validate_interests!(interests)
    interests = interests.keys.map { Interest.new(name: it.to_s.upcase.strip) }
    interests.all?(&:validate!)
  end

  def build_interest_relations(post, post_tags)
    post_tags ||= {}
    validate_interests!(post_tags)
    all_tags = post_tags.keys.map { |name| { name: name.to_s.upcase.strip } }
    Interest.insert_all(all_tags, returning: false)
    interests = Interest.where(name: all_tags.map { it[:name] })

    post_rel = post_tags.each_with_object({}) do |(name, weight), hash|
      hash[name.to_s.upcase.strip] = { interestable_type: "Post", interestable_id: post.id, weight: weight.fdiv(100) }
    end

    interests.each_with_object([]) do |interest, relations|
      n = interest.name
      relations << post_rel[n].merge(interest_id: interest.id) if post_rel[n]
    end
  end
end
