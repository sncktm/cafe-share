class User < ApplicationRecord
  validates :name, {presence: true}

  validates :email, {presence: true, uniqueness: true}

  validates :location, {presence: true}

  validates :password, {presence: true}

  def posts
    return Post.where(user_id: self.id)
  end
end
