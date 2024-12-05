class ProfilesController < ApplicationController	
	skip_before_action :verify_profile_existence, only: [:new, :create]
  before_action :set_profile, only: [:show, :update, :edit]
  before_action :authorize_user, only: [:update, :edit]
  
  def show  	
  end
	def new		
		@profile = current_user.build_profile
	end
	
	def edit
	end

	def create
		@profile = current_user.build_profile(profile_params)
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
		params.expect(profile: [:first_name, :last_name, :bio, :country, :city, :profession, :avatar, :dob, :gender])
	end

	def set_profile
		@profile = Profile.includes(:user, avatar_attachment: :blob).find_by!({user: {username: params[:username]}})
	end
end
