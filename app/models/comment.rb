class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :commentable, polymorphic: true, counter_cache: true
  has_many :comments, as: :commentable, dependent: :destroy
  validates :content, presence: true

  scope :ordered_for_user, ->(current_user) {
    order(
      Arel.sql("CASE WHEN user_id = #{current_user.id} THEN 0 ELSE 1 END"),
      created_at: :desc
    )
  }
end
