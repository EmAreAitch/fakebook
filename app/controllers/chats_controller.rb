class ChatsController < ApplicationController
	before_action :users_are_connected, only: [:show]	
	def index
		@chats = Chat
		.includes(:sender, :receiver)
		.where(sender: current_user).or(Chat.where(receiver: current_user))
		.order(updated_at: :desc)		

		@follows = Follow
		.includes(:follower,:followed)
		.select("*")
		.from(
			Follow                                                                                                                           
			.select("DISTINCT ON (LEAST(follower_id,followed_id), GREATEST(follower_id,followed_id)) *")
			.where(follower: current_user).or(Follow.where(followed: current_user))                                                                                            
			.accepted
		).order(updated_at: :desc)		
	end	

	def show
		@chat = Chat
		.includes(:sender, :receiver, messages: :user)
		.find_by(sender: {username: [current_user.username, username_param]}, receiver: {username: [current_user.username, username_param]})
		@chat = Chat.new(sender: current_user, receiver: User.find_by!(username: username_param)) unless @chat.present?
	end

	def create
		receiver = User.find(params.expect(chat: [:receiver_id])[:receiver_id])
		@chat = Chat.new(chat_params.merge({sender: current_user, receiver: }))
		unless @chat.save			
			flash.now.alert = @chat.errors.full_messages.join(", ")
			render turbo_stream: render_flash_stream, status: :unprocessable_entity
		end
	end

	def update		
		@chat = Chat.find_by("(sender_id = :user_id OR receiver_id = :user_id) AND id = :id",id: params.expect(:id), user_id: current_user.id)
		unless @chat.update(chat_params)			
			flash.now.alert = @chat.errors.full_messages.join(", ")
			render turbo_stream: render_flash_stream, status: :unprocessable_entity
		end
	end

	private


	def chat_params		
		params.expect(chat: [messages_attributes: ["0": [:content]]]).deep_merge({messages_attributes: { "0": { user: current_user}}})
	end

	def users_are_connected
		existing_connection = Follow
  	.joins(:follower, :followed)
		.exists?(followed: {username: [current_user.username,username_param]}, follower: {username: [current_user.username,username_param]})
		head :unauthorized unless existing_connection		
	end
end
