class SessionsController < Devise::SessionsController
  skip_before_filter :authenticate_user!
end
