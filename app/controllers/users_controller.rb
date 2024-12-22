class UsersController < ApplicationController
  before_action :authenticate_user, {only: [:index, :show, :edit, :update]}

  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
  def show
    @user = User.find_by(id: params[:id])
  end
  def new
    @user = User.new
  end
  def create
    @user = User.new(name: params[:name], email: params[:email], prefecture_id: params[:prefecture_id], image_name: "/user_images/default_user.png", password: params[:password])
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録が完了しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/new")
    end
    
  end
  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    
    @user.name = params[:name]
    @user.email = params[:email]
    @user.prefecture_id = params[:prefecture_id]
    
    if params[:image]
      uploaded_file = params[:image]
      result = Cloudinary::Uploader.upload(uploaded_file.path)
      
      @user.image_name = result['url']
    end
  
    if @user.save
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit", status: :unprocessable_entity)
    end
  end
  
  def login_form
    
  end
  def login
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to("/posts/index")
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form", status: :unprocessable_entity)
    end
  end
  
  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end

  def likes
    user_posted_cafes = Post.where(user_id: @current_user.id).pluck(:cafe_name)
    @prefecture_id = params[:prefecture_id]
    @status = params[:status]
    @user = User.find_by(id: params[:id])
    
    @likes = Like.where(user_id: @user.id).includes(:post)
  
    if @prefecture_id.present?
      @likes = @likes.joins(:post).where(posts: { prefecture_id: @prefecture_id })
    end
  
    if @status == "unexplored"
      @likes = @likes.joins(:post).where.not(posts: { cafe_name: user_posted_cafes })
    end
  
    @likes_count = @likes.count
  end
  
end
