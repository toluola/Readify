module Authenticable
  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last

    if token.blank?
      render json: { error: 'Missing or invalid Authorization header', status: false }, status: :unauthorized
      return
    end

    begin
      user = JsonWebToken.decode(token)
      @current_user = User.find_by(id: user[:user_id])

      unless @current_user
        render json: { error: 'User not found', status: false }, status: :unauthorized
        return
      end
    rescue JWT::DecodeError
      render json: { error: 'Unauthorized', status: false }, status: :unauthorized
    end
  end
end
