class Interest < ApplicationRecord
  has_many :interest_relations, dependent: :delete_all
  has_many :users, through: :interest_relations, source: :interestable, source_type: "User"
  has_many :posts, through: :interest_relations, source: :interestable, source_type: "Post"

  before_save :uppercase_name

  validates :name, presence: true

  private

  def uppercase_name
    self.name = name.upcase.strip if name.present?
  end
end
