module CommentsHelper
	include ActionView::RecordIdentifier
	include Rails.application.routes.url_helpers

	def commentable_dom_id(comment, prefix)
		commentable_type, commentable_id = comment.commentable_type.constantize, comment.commentable_id		
		dom_id(commentable_type.new(id: commentable_id), prefix)
	end

	def list_button_text(comment)
		pluralize(comment.commentable.comments_count, (comment.commentable.is_a?(Post) ? "comment" : "reply"))
	end

	def comment_index_path(comment)
		comment.commentable.is_a?(Post) ? post_comments_path(comment.commentable) : post_comment_replies_path(comment.post_id, comment.commentable)
	end

	def comment_form_url_path(comment)
		case comment.commentable_type
		when "Post"
			post_comments_path(comment.commentable_id)
		when "Comment"
			post_comment_replies_path(comment.post_id, comment.commentable_id)
		end
	end
end
