class BooklistBooksController < ApplicationController
  include Authenticable

  before_action :authenticate_user
  before_action :set_booklist

  # POST /booklists/:booklist_id/booklist_books
  def create
    @booklist_book = @booklist.booklist_books.new(booklist_book_params)

    if @booklist_book.save
      render json: { message: 'BookList added successfully', data: {}, status: true }, status: :ok
    else
      render json: { error: @booklist_book.errors.full_messages, status: false }, status: :unprocessable_entity
    end
  end

  # DELETE /booklists/:booklist_id/booklist_books/:id
  def destroy
    @booklist_book = @booklist.booklist_books.find_by(id: params[:book_id])
    @booklist_book.destroy
  end

  private

  def set_booklist
    @booklist = current_user.booklists.find(params[:booklist_id])
  end

  def booklist_book_params
    params.permit(:book_id)
  end
end
