module ApplicationHelper
	include Rails.application.routes.url_helpers

	def link_to_follow(follow)		
		if follow.persisted?
			if follow.follower_id == current_user.id				
				button_to follow.accepted? ? "Unfollow" : "Destroy request", follow_path(follow), method: :delete
			elsif follow.accepted?				
				button_to "Remove", follow_path(follow), method: :delete
			else
				(button_to "Accept", accept_follow_path(follow), method: :patch) +
				(button_to "Reject", follow_path(follow), method: :delete)
			end
		else
			button_to "Follow", follows_path, params: {user_id: follow.followed_id}
		end

	end
end
