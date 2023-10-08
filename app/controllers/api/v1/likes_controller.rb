class LikesController < ApplicationController
  def create
    @book = Book.find_by!(id: params[:book_id])
    current_user.likes.create(book: @book)
    render json: { message: 'Book liked successfully' }, status: :created
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Book not found', status: false }, status: :not_found
  end

  def destroy
    @like = current_user.likes.find(params[:book_id])
    @like.destroy
    render json: { message: 'Book unliked successfully' }, status: :ok
  end
end
