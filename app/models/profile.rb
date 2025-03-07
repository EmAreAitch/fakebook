class Profile < ApplicationRecord
  belongs_to :user
  accepts_nested_attributes_for :user, update_only: true
  enum :gender, %i[male female other]
  validates :first_name, :last_name, :dob, :gender, :bio, presence: true
  validates :bio, length: { in: 50..250 }
  validates :dob,
            comparison: {
              less_than_or_equal_to: 13.years.ago.to_date,
              message: "must be at least 13 years old"
            }
  after_create { self.user.update(profile_completed: true) }

  def fullname
    "%s %s" % [ first_name, last_name ]
  end

  def age
    Date.today.year - dob.year
  end

  def to_param
    persisted? ? user.username : nil
  end
end
