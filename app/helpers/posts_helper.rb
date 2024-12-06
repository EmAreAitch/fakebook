module PostsHelper
	def post_liked_by_user(posts_liked_ids, post)
		posts_liked_ids.bsearch { |id| id <=> post.id}.present?
	end

	def like_button_text(posts_liked_ids, post)
		res = post_liked_by_user(posts_liked_ids, post) ? "Unlike %d" : "Like %d"
		res % post.likes_count
	end
end
