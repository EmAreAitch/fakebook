class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :webauthn_credentials, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :likes, dependent: :delete_all
  has_many :posts_liked, through: :likes, source: :post

  validates :webauthn_id, uniqueness: true, allow_nil: true
  validates :username, presence: true, uniqueness: { case_sensitive: false }  

  before_save { self.username = self.username.downcase }
  
  validates :username, format: { with: /\A[a-z0-9_]{3,15}\z/,
    message: "only allows lower case letters, numbers & underscores" }

  def posts_liked_ids_sorted
    posts_liked.order(:id).pluck(:id)
  end
end
