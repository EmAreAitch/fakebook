class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :webauthn_credentials, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_one_attached :avatar
  has_many :likes, dependent: :delete_all
  has_many :posts_liked, through: :likes, source: :post
  has_many :comments, dependent: :destroy

  has_many :follower_relationships,
           class_name: "Follow",
           foreign_key: "followed_id"
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :following_relationships,
           class_name: "Follow",
           foreign_key: "follower_id"
  has_many :followings, through: :following_relationships, source: :followed
  has_many :interest_relations, as: :interestable, dependent: :destroy
  has_many :interests, through: :interest_relations

  # Custom methods for specific statuses
  def accepted_followers
    followers.merge(Follow.accepted)
  end

  def pending_followers
    followers.merge(Follow.pending)
  end

  def accepted_followings
    followings.merge(Follow.accepted)
  end

  def pending_followings
    followings.merge(Follow.pending)
  end

  validates :webauthn_id, uniqueness: true, allow_nil: true
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  before_save { self.username = self.username.downcase }

  validates :username,
            format: {
              with: /\A[a-z0-9_]{3,15}\z/,
              message: "only allows lower case letters, numbers & underscores"
            }, allow_nil: true

  def posts_liked_ids_sorted
    posts_liked.order(:id).pluck(:id)
  end
end
