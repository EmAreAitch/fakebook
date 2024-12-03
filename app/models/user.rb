class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :webauthn_credentials, dependent: :destroy

  validates :webauthn_id, uniqueness: true, allow_nil: true
  validates :username, presence: true, uniqueness: { case_sensitive: false }  

  before_save { self.username = self.username.downcase }
  
  validates :username, format: { with: /\A[a-z0-9_]{3,15}\z/,
    message: "only allows lower case letters, numbers & underscores" }
end
