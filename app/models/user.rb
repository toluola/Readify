class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A\S+@\S+\.\S+\z/ }
  validates :password, presence: true, length: { minimum: 6 }, format: { with: /\A[a-zA-Z0-9]+\z/, message: 'must be alphanumeric' }, allow_nil: true

  has_many :likes, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :booklists, dependent: :destroy

  before_save :downcase_email

  def downcase_email
    self.email = email.downcase
  end
end
