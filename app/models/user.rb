class User < ActiveRecord::Base
  has_many :victories

  validates :email, presence: true, uniqueness: true
  validates :nickname, presence: true, uniqueness: true
end