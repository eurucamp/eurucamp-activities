class PasswordsController < Devise::PasswordsController
  skip_before_action :authenticate_user!
end
