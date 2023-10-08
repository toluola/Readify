class Book < ApplicationRecord
  has_many :reviews
  has_many :likes, dependent: :destroy
  has_many :booklist_books, dependent: :destroy
  has_many :booklists, through: :booklist_books
end
