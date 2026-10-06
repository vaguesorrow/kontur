class Profile < ApplicationRecord
  belongs_to :user

  validates :display_name, presence: true
  validates :user_id, uniqueness: true
end
