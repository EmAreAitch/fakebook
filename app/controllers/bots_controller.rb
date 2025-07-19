class BotsController < ApplicationController  
  def new
    @bot = Bot.new
    4.times { @bot.interests.build }
  end

  def create
    tags = prepare_tags
    @bot_request = BotRequest.new(tags:, user: current_user)
    if @bot_request.save
      redirect_to root_path, notice: "Success"
    else
      flash.now.alert = @bot_request.errors.full_messages.join(", ")      
      @bot = Bot.new
      4.times { @bot.interests.build }
      render :new, status: :unprocessable_entity
    end
  end

  private

  def authorize_admin!
    return if admin?(current_user)    
    redirect_to root_path,
                alert: "You are not authorized to access this page."                
  end

  def prepare_tags
    raw_tags = bot_params.to_h["interests_attributes"].values
    raw_tags.map { it[:name].to_s.upcase.strip }
  end

  def bot_params
    params.expect(bot: { interests_attributes: [ [ :name ] ] })
  end
end
