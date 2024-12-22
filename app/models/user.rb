class User < ApplicationRecord
  belongs_to :prefecture

  has_secure_password

  validates :name, {presence: true}
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :prefecture_id, {presence: true}

  def posts
    return Post.where(user_id: self.id)
  end

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :prefecture
end
