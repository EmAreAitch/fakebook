class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  after_save if: [:accepted?, :status_previously_changed?] do 
    User.increment_counter(:followers_count, self.followed_id)
    User.increment_counter(:followings_count, self.follower_id)
  end

  after_destroy if: :accepted? do 
    User.decrement_counter(:followers_count, self.followed_id)
    User.decrement_counter(:followings_count, self.follower_id)
  end

  enum :status,[:pending,:accepted], validate: true

  validates :follower_id, uniqueness: { scope: :followed_id }
  validates :followed_id, comparison: { other_than: :follower_id, message: "cannot be same as follower" }
  scope :accepted, -> { where(status: :accepted) }
  scope :pending, -> { where(status: :pending) }
  scope :of_user, ->(user) { where(followed: user).or(where(follower: user)) }

  def of_user(user)
    follower == user or followed == user
  end
end

