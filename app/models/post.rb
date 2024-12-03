class Post < ApplicationRecord
  has_one_attached :video
  has_many_attached :images
end
