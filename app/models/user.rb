class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :confirmable, :omniauthable

  include DeviseTokenAuth::Concerns::User

  has_many :victories, dependent: :destroy
  has_many :votes, dependent: :destroy

  validates :nickname, presence: true, uniqueness: true
end