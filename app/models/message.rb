class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  validates :content, presence: true

  after_create { broadcast_append_to [self.chat.sender_id, self.chat.receiver_id].sort }
end
