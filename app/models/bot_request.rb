class BotRequest < ApplicationRecord
  after_create_commit :schedule_bot_creation_job
  belongs_to :user
  belongs_to :bot, optional: true, dependent: :destroy

  validates :tags, presence: true
  validate  :validate_tags_elements
  validates :bot_id, uniqueness: {allow_nil: true}

  private

  def validate_tags_elements
    return if tags.blank?

    blank_found      = tags.any?(&:blank?)
    invalid_count   = !(4..7).include?(tags.length)    
    duplicates = tags.uniq.length != tags.length
    
    errors.add(:tags, "must not include blank values") if blank_found
    errors.add(:tags, "must contain between 4 and 7 tags") if invalid_count
    errors.add(:tags, "must be unique") if duplicates
  end

  def schedule_bot_creation_job
    GenerateBotJob.perform_later(self)
  end
end
