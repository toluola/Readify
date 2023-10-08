class BooklistsController < ApplicationController
  include Authenticable

  before_action :authenticate_user
  before_action :set_booklist, only: [:show, :update, :destroy]

  # GET /booklists
  def index
    @booklists = current_user.booklists
    render json: { message: 'BookLists fetched successfully', data: @booklists, status: true }, include: :books, status: :ok
  end

  # GET /booklists/1
  def show
    render json: { message: 'BookList fetched successfully', data: @booklist, status: true }, include: :books, status: :ok
  end

  # POST /booklists
  def create
    @booklist = current_user.booklists.new(booklist_params)

    if @booklist.save
      render json: { message: 'BookList Created successfully', data: @booklist, status: true }, status: :ok
    else
      render json: { error: @booklist.errors.full_messages, status: false }, status: :unprocessable_entity
    end
  end

  # DELETE /booklists/1
  def destroy
    @booklist.destroy
    render json: { message: 'BookList Created successfully', data: {}, status: true }, status: :ok
  end

  private

  def set_booklist
    @booklist = current_user.booklists.find_by!(id: params[:book_id])
  end

  def booklist_params
    params.permit(:name)
  end
end
