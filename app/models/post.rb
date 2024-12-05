class Post < ApplicationRecord
  has_one_attached :video, dependent: :delete_all, strict_loading: true
  has_many_attached :images, dependent: :delete_all, strict_loading: true

  scope :with_attachments, -> { includes(video_attachment: :blob, images_attachments: :blob) }
end
