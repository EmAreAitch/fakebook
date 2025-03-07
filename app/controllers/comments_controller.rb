class CommentsController < ApplicationController
	include CommentsHelper
	before_action :set_commentable_and_post, only: [:index,:create, :new]		

	def index		
		@comments = Comment.includes(:user).where(**@commentable, post_id: @post_id).ordered_for_user(current_user)
		@comments_dom_id = commentable_dom_id(Comment.new(**@commentable),"comments")
	end

	def new
		@comment = Comment.new(**@commentable, post_id: @post_id)		
	end

	def create
		@comment = current_user.comments.build(**params.expect(comment: [:content]), **@commentable, post_id: @post_id)						
		turbo_streams_list = []	
		if @comment.save
			@comments_dom_id = commentable_dom_id(@comment, "comments")
			flash.now.notice = "Thanks for commenting"			
			@form_comment = Comment.new(**@commentable, user: current_user, post_id: @post_id)
		else
			render turbo_stream: turbo_stream.update(commentable_dom_id(@comment, "comment_form"), method: :morph, partial: "form", locals: { comment: @comment })
		end
	end

	private

	def set_commentable_and_post
		if params.include?(:comment_id)
			@commentable = {commentable_type: "Comment", commentable_id: params.expect(:comment_id)}
		else
			@commentable = {commentable_type: "Post", commentable_id: params.expect(:post_id)}
		end
		@post_id = params.expect(:post_id)
	end
end
