class Interest < ApplicationRecord
  has_many :interest_relations, dependent: :destroy
  has_many :users, through: :interest_relations, source: :interestable, source_type: "User"
  has_many :posts, through: :interest_relations, source: :interestable, source_type: "Post"
end
