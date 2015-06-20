class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :authentications, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :created_activities, class_name: "Activity", foreign_key: "creator_id", dependent: :nullify
  has_many :activities_participated_in, through: :participations

  validates :email, presence: true

  before_save :ensure_authentication_token

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  # TODO: extract to module and then to a gem / engine
  def apply_omniauth(omniauth)
    provider, uid, info = omniauth.values_at('provider', 'uid', 'info')
    unless info.blank?
      self.email = info['email'] if email.blank?
      self.name  = info['name']  if name.blank?
    end

    apply_provider_handle(omniauth)
    authentications.build(provider: provider, uid: uid)
  end

  def apply_provider_handle(omniauth)
    provider, info = omniauth.values_at('provider', 'info')

    # su*ks - refactor it
    unless info.blank?
      case provider
        when /github/
          self.github_handle  = info['nickname'] if github_handle.blank?
        when /twitter/
          self.twitter_handle = info['nickname'] if twitter_handle.blank?
      end
    end
    self
  end

  def update_without_password(params, *options)
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def password_required?
    !any_oauth_connected? && super
  end

  def no_oauth_connected?
    !any_oauth_connected? && encrypted_password.present?
  end

  def connected_with_twitter?
    provider_connected?('twitter')
  end

  def connected_with_github?
    provider_connected?('github')
  end

  private

    def generate_authentication_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(authentication_token: token).first
      end
    end

    def any_oauth_connected?
      authentications.any?
    end

    def provider_connected?(provider)
      authentications.where(provider: provider).any?
    end

    def paper_exists?(paper)
      papers.exists?(paper)
    end

end
