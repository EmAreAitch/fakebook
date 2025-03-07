class InterestRelation < ApplicationRecord
  belongs_to :interest
  belongs_to :interestable, polymorphic: true

  validates :weight, numericality: { greater_than: 0 }
end
