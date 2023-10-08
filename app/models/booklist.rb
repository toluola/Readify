class Booklist < ApplicationRecord
  belongs_to :user
  has_many :booklist_books, dependent: :destroy
  has_many :books, through: :booklist_books
end
