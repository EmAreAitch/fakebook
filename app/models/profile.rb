class Profile < ApplicationRecord
  belongs_to :user
  after_create_commit :generate_timeline, unless: :user_is_human?
  accepts_nested_attributes_for :user, update_only: true
  enum :gender, %i[male female other]

  validates :first_name, :last_name, :dob, :gender, :bio, presence: true
  validates :bio, length: { maximum: 250 }
  validates :dob,
            comparison: {
              less_than_or_equal_to: 13.years.ago.to_date,
              message: "must be at least 13 years old"
            },
            if: :user_is_human?

  after_create { user.update(profile_completed: true) }

  scope :search, ->(term) {
    t = "%#{term}%"
    joins(:user).where(<<-SQL.squish, term: t)
      users.username   ILIKE :term OR
      profiles.first_name ILIKE :term OR
      profiles.last_name  ILIKE :term OR
      profiles.bio        ILIKE :term OR
      profiles.profession ILIKE :term
    SQL
  }

  def fullname
    "#{first_name} #{last_name}"
  end

  def age
    Date.today.year - dob.year
  end

  def to_param
    persisted? ? user.username : nil
  end

  private

  # Adjust this method based on how you distinguish human users from bots.
  def user_is_human?
    return true unless user.present?
    # For example, if you use STI and human users are of type "User":
    user.type == "User"
    # Alternatively, if you have a boolean flag on the user model:
    # !user.bot?
  end

  def generate_timeline
    GenerateTimelineJob.perform_later(user)
  end
end
