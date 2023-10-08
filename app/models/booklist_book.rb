class BooklistBook < ApplicationRecord
  belongs_to :booklist
  belongs_to :book
end
