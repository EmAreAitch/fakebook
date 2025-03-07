class FollowsController < ApplicationController
	def index
		@user = User.find_by!(username: params[:profile_username])
		@follow_requests = 
		Follow
		.includes(:follower,:followed)
		.where(follower: @user).or(Follow.where(followed: @user))		
		.group_by do |record| 
			if record.follower == @user
				record.accepted? ? "followings" : "pending_following_requests"
			else
				record.accepted? ? "followers" : "pending_follower_requests"
			end 
		end
	end	

	def create
		followed = User.find_by(username: username_param)
		follow = Follow.new(follower: current_user, followed:)		
		if follow.save
			user_details = {follower_username: current_user.username, followed_username: followed.username }
			render json: follow.as_json(except: [:created_at, :updated_at]).merge(user_details)
		else			
      render json: follow.errors.full_messages.join(", "), status: :unprocessable_entity
		end
	end

	def accept
		@follow = Follow.find_by!(id: params[:id], followed: current_user)
		respond_to do |f|
			begin	
				@follow.accepted!	if @follow.pending?
				f.html {redirect_to profile_follows_path(username_param), notice: "Success"}
				f.json { head :no_content }
			rescue
				f.html { redirect_to profile_follows_path(username_param), alert: (follow&.errors.full_messages.join(", ") || "Something went wrong"), status: :unprocessable_entity }
				f.json { render json: (follow&.errors.full_messages.join(", ") || "Something went wrong"), status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@follow = Follow.find_by("(followed_id = :user_id OR follower_id = :user_id) AND id = :id",id: params[:id], user_id: current_user.id)
		@follow&.destroy!				
		respond_to do |f|
			f.html {redirect_to profile_follows_path(username_param), notice: "Success"}
			f.json { head :no_content }
		end		
	end
end
