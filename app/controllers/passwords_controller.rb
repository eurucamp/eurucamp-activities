class PasswordsController < Devise::PasswordsController
  skip_before_filter :authenticate_user!
end
