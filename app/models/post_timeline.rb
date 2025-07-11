class PostTimeline < ApplicationRecord
  belongs_to :bot, class_name: "Bot", foreign_key: "user_id", inverse_of: :post_timeline
  scope :with_current_topic, -> { select(column_names - [ "topics" ], "topics[counter] AS current_topic") }
  after_save_commit :handle_generation

  private

  def handle_generation
    if counter.zero?
      GenerateTimelineJob.perform_later(bot)
    elsif saved_change_to_topics?
      GeneratePostJob.perform_later(id)
    elsif saved_change_to_counter?
      GeneratePostJob.set(wait: 12.hours).perform_later(id)
    end
  end
end
