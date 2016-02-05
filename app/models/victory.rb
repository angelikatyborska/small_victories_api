class Victory < ActiveRecord::Base
  belongs_to :user
  has_many :votes, dependent: :destroy

  validates :body, presence: true
  validates :user, presence: true

  def votes_count
    votes.inject(0) { |count, vote| count + vote.value }
  end
end