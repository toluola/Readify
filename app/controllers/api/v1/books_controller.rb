class Api::V1::BooksController < ApplicationController
  include Authenticable

  before_action :authenticate_user

  def index
    @limit = params[:limit] || 10 # Default limit is 10, can be adjusted
    @offset = params[:offset] || 0

    @books = Book.limit(@limit).offset(@offset)
    if @books
      render json: { message: 'Books fetched successfully', data: @books, status: true }, status: :ok
    else
      render json: { error: @books.errors.full_messages, status: false }, status: :unprocessable_entity
    end
  end

  def review
    @book = Book.find_by(id: review_params[:book_id])

    unless @book
      render json: { error: 'Book not found', status: false }, status: :not_found
      return
    end

    @review = @book.reviews.build(content: review_params[:content], user: @current_user)

    if @review.save
      render json: { message: 'Review was successfully created.', data: @review, status: true }, status: :ok
    else
      render json: { error: @review.errors.full_messages, status: false }, status: :unprocessable_entity
    end
  end

  def show
    @book = Book.includes(:reviews).find_by!(id: params[:book_id])
    @like = @current_user.likes.find_by(book: @book)

    render json: { message: 'Book fetched successfully.', data: @book, liked: @like ? true : false,  status: true }, include: :reviews, status: :ok

    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Book not found', status: false }, status: :not_found
  end

  private

  def review_params
    params.permit(:content, :book_id)
  end
end
