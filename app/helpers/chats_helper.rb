module ChatsHelper
	def opposite_username(chat, user)
		chat.sender == user ? chat.receiver.username : chat.sender.username
	end
end
