class PostsController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, {only: [:destroy]}
  def index
    @posts = Post.all.order(created_at: :desc)
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
        @post.image = "#{@post.id}.jpg"
        image = params[:image]
        File.binwrite("public/posts_images/#{@post.image}", image.read)
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
