module ControllerHelpers
  def should_authorize(action, subject)
    expect(controller).to receive(:authorize!).with(action, subject).and_return(true)
  end

  def sign_in(user = double('user'))
    if user.nil?
      allow(request.env['warden']).to receive(:authenticate!).
          and_throw(:warden, {scope: :user})
      allow(controller).to receive_messages current_user: nil
    else
      allow(request.env['warden']).to receive_messages authenticate!: user
      allow(controller).to receive_messages current_user: user
    end
  end
end
