class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit]
  before_action :set_posts_liked_ids, only: %i[index show explore]
  # GET /posts or /posts.json
  def index
    @posts = Post.with_attachments_and_user.order(created_at: :desc).where(user: current_user.followings).all  
    @user = current_user    
  end

  def explore 
    @posts = Post.with_attachments_and_user.order(created_at: :desc).all      
    @user = current_user  
  end

  # GET /posts/1 or /posts/1.json
  def show
    @commentable = @post
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit    
    authorize_user  
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    respond_to do |format|
      if @post.save
        format.html do
          redirect_to @post, notice: "Post was successfully created."
        end
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    @post = Post.find(params.expect(:id))
    authorize_user
    respond_to do |format|
      if @post.update(post_params)
        format.html do
          redirect_to @post, notice: "Post was successfully updated."
        end
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post = Post.find(params.expect(:id))
    authorize_user
    @post.destroy!

    respond_to do |format|
      format.html do
        redirect_to posts_path,
                    status: :see_other,
                    notice: "Post was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end

  def like
    like = Like.new(post_id: params[:id], user: current_user)
    if like.save
      head :created
    else
      render json: like.errors.full_messages.join(", "),
             status: :unprocessable_entity
    end
  end

  def unlike
    like = Like.find_by(post_id: params[:id], user: current_user)
    if like&.destroy!
      head :no_content
    else
      render json: "Something went wrong", status: :unprocessable_entity
    end
  end

  private

  def authorize_user
		unless @post.user == current_user
			head :unauthorized
		end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.with_attachments_and_user.find(params.expect(:id))    
  end

  def set_posts_liked_ids
    @posts_liked_ids = current_user.posts_liked_ids_sorted
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.expect(post: [ :content, :video, images: [] ]).merge(
      user: current_user
    )
  end
end
