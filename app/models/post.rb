class Post < ApplicationRecord
  belongs_to :prefecture

  validates :cafe_name, {presence: true, length: {maximum: 50}}
  validates :prefecture_id, {presence: true}
  validates :image, {presence: true}
  validates :content, {presence: true, length: {maximum: 140}}
  validates :user_id, {presence: true}

  def user
    return User.find_by(id: self.user_id)
  end

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :prefecture
end
