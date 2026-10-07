class User < ApplicationRecord
  has_one :profile, dependent: :destroy

  # Devise uses encrypted_password internally; the database stores password_digest.
  alias_attribute :encrypted_password, :password_digest

  enum :role, { user: "user", admin: "admin" }, validate: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
