class Post < ApplicationRecord
  has_one_attached :video
  has_many_attached :images
  has_many :likes, dependent: :delete_all
  has_many :users_liked, through: :likes, source: :user
  has_many :comments, as: :commentable
  has_many :interest_relations, as: :interestable, dependent: :destroy
  has_many :interests, through: :interest_relations
  has_many :all_comments, dependent: :destroy, class_name: :Comment
  belongs_to :user
  scope :with_attachments_and_user, -> { includes(user: [{avatar_attachment: :blob},:profile], video_attachment: :blob, images_attachments: :blob) }
  validates :content, presence: true
end
