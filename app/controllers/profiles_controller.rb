class ProfilesController < ApplicationController	
	skip_before_action :verify_profile_existence, only: [:new, :create]
  before_action :set_profile, only: [:show, :update, :edit]
  before_action :authorize_user, only: [:update, :edit]
  
  def show   	  	
  end

  def follow_status
  	@follows = Follow
  	.joins(:follower,:followed)
		.where(followed: {username: [current_user.username,username_param]}, follower: {username: [current_user.username,username_param]})
		.select("follows.*", follower: {username: :follower_username}, followed: {username: :followed_username})

		render json: @follows.as_json(except: [:created_at,:updated_at])
  end

	def new		
		@profile = current_user.build_profile
	end
	
	def edit
	end

	def create
		@profile = Profile.new(profile_params)
		if @profile.save			
			redirect_to root_path, notice: "WELCOME TO FAKEBOOK!!!!!"
		else
			render :new, status: :unprocessable_entity
		end
	end

	def update		
		if @profile.update(profile_params)			
			redirect_to profile_path(@profile), notice: "Profile Updated Successfully"
		else
			render :new, status: :unprocessable_entity
		end
	end

	private

	def authorize_user
		unless @profile.user == current_user
			head :unauthorized
		end
	end

	def profile_params		
		params.expect(profile: [:first_name, :last_name, :bio, :country, :city, :profession, :dob, :gender, user_attributes: [:avatar]])
		.merge({user: current_user})
	end

	def avatar_param
		params.expect(user: [:avatar])
	end

	def set_profile
		@profile = Profile.includes(user: {avatar_attachment: :blob}).find_by!({user: {username: username_param}})
	end
end
