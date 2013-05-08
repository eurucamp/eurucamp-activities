class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :authentications

  validates :name, presence: true
  validates :email, presence: true

  # TODO: extract to module and then to a gem / engine
  def apply_omniauth(omniauth)
    provider, uid, info = omniauth.values_at('provider', 'uid', 'info')
    self.email = info['email'] if email.blank?
    self.name  = info['name']  if name.blank?

    apply_provider_handle(omniauth)
    authentications.build(provider: provider, uid: uid)
  end

  def apply_provider_handle(omniauth)
    provider, info = omniauth.values_at('provider', 'info')

    case provider
      when /github/
        self.github_handle  = info['nickname'] if github_handle.blank?
      when /twitter/
        self.twitter_handle = info['nickname'] if twitter_handle.blank?
    end
  end

  def password_required?
    (authentications.empty? || password.present?) && super
  end

  def connected_with_twitter?
    authentications.where(provider: 'twitter').first
  end

  def connected_with_github?
    authentications.where(provider: 'github').first
  end

end
