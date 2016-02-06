class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :victory

  validates :user, presence: true
  validates :victory, presence: true, uniqueness: { scope: :user, message: 'can\'t vote twice for the same victory'}
  validates :value, presence: true, inclusion: { in: [1, -1] }

  after_save :update_victory_rating
  after_destroy :subtract_from_victory_rating

  def update_victory_rating
    old = value_was || 0
    new = value || 0
    victory.update_attribute(:rating, victory.rating + new - old)
  end

  def subtract_from_victory_rating
    victory.update_attribute(:rating, victory.rating - value)
  end
end