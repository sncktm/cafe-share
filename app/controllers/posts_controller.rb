class PostsController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, {only: [:destroy]}
  def index
    user_posted_cafes = Post.where(user_id: @current_user.id).pluck(:cafe_name)
    @prefecture_id = params[:prefecture_id]
    @status = params[:status]
    posts = Post.all

    if @prefecture_id.present?
      posts = Post.where(prefecture_id: @prefecture_id)
    end

    if @status == "unexplored"
      posts = posts.where.not(cafe_name: user_posted_cafes)
    end
    @posts = posts.order(created_at: :desc)
  end
  def show
    @post = Post.find_by(id: params[:id])
    @user = @post.user
    @likes_count = Like.where(post_id: @post.id).count
  end
  def new
    @post = Post.new
  end

    def create
      @post = Post.new(cafe_name: params[:cafe_name], prefecture_id: params[:prefecture_id], content: params[:content],
                       user_id: @current_user.id)
  
      if @post.save
        if params[:image]
          uploaded_file = params[:image]
          result = Cloudinary::Uploader.upload(uploaded_file.path)
  
          @post.image_url = result['url']
          @post.save
        end
  
        flash[:notice] = "投稿しました"
        redirect_to("/posts/index")
      else
        render("posts/new", status: :unprocessable_entity)
      end
    end
 
  

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to("/posts/index")
  end

  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end

  
end
