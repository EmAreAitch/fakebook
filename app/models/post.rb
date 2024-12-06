class Post < ApplicationRecord
  has_one_attached :video
  has_many_attached :images
  has_many :likes, dependent: :delete_all
  has_many :users_liked, through: :likes, source: :user
  belongs_to :user
  scope :with_attachments_and_user, -> { includes(:user, video_attachment: :blob, images_attachments: :blob) }
end
