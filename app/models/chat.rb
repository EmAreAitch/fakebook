class Chat < ApplicationRecord
  attr_readonly :receiver_id, :sender_id

  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  has_many :messages, dependent: :destroy
  accepts_nested_attributes_for :messages
  
  validates :sender_id, comparison: { other_than: :receiver_id, message: "cannot be same as receiver" }
  validate :chat_is_unique
  validate :users_are_connected
  scope :between, -> (user1_id, user2_id) { find_by(sender_id: [user1_id, user2_id], receiver_id: [user1_id, user2_id]) }  

  after_create_commit { broadcast_replace_to [self.sender_id, self.receiver_id].sort, target: "chat_form", partial: "chats/form", chat: Chat.new }

  private  

  def chat_is_unique
    if sender_id.present? and receiver_id.present? and sender_id != receiver_id   
      existing_chat = Chat.where(
        sender_id: [sender_id, receiver_id], receiver_id: [sender_id, receiver_id]
      ).where.not(id: id).exists?
      
      errors.add(:base, "Chat between these users already exists") if existing_chat      
    end    
  end

  def users_are_connected
    if sender_id.present? and receiver_id.present? and sender_id != receiver_id   
      existing_connection = Follow
      .joins(:follower, :followed)
      .exists?(follower: {id: [sender_id, receiver_id], type: "User"}, followed: {id: [sender_id, receiver_id], type: "User"})
      
      errors.add(:base, "Users are not connected by follow") unless existing_connection
    end    
  end
end
