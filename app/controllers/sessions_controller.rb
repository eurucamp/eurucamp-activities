class SessionsController < Devise::SessionsController
  respond_to :json

  skip_before_filter :authenticate_user!

  def create
    super do |user|
      if request.format.json?
        data = {
          token: user.authentication_token,
          email: user.email
        }
        render json: data, status: 201 and return
      end
    end
  end
end
