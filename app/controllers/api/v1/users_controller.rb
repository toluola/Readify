class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    puts
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { message: 'User created successfully', token: token, user: sanitize_user(user), status: true }, status: :created
    else
      render json: { error: user.errors.full_messages, status: false }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: {message: 'User logged in successfully', token: token, user: sanitize_user(user), status: true }, status: :ok
    else
      render json: { error: 'Invalid email or password', status: false }, status: :unauthorized
    end
  end

  private

  def sanitize_user(user)
    user.as_json(except: :password_digest)
  end

  def user_params
    params.permit(:email, :name, :password)
  end
end
