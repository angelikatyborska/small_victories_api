class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :victory

  validates :user, presence: true
  validates :victory, presence: true, uniqueness: { scope: :user, message: 'can\'t vote twice for the same victory'}
  validates :value, presence: true, inclusion: { in: [1, -1] }
end