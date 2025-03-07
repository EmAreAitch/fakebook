class ApplicationController < ActionController::Base
  include ActiveStorage::SetCurrent
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :verify_profile_existence

  protected

  def render_flash_stream
    turbo_stream.update("flash",partial: "flash")
  end

  private

  def verify_profile_existence
    if user_signed_in?
      redirect_to new_profile_path, notice: "Complete your profile first before moving further!" unless current_user.profile_completed?
    end
  end  

  def username_param
    params.expect(:username)
  end
end
