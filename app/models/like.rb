class Like < ApplicationRecord
  belongs_to :post

  validates :user_id, {presence: true}
  validates :post_id, {presence: true}
end
