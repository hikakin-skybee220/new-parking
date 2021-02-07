class User < ApplicationRecord
  has_one :card, dependent: :delete #カードは一人1枚まで

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable,:omniauthable, omniauth_providers: %i[facebook twitter google_oauth2]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      # user.image = auth.info.image.gsub("_normal","") if user.provider == "twitter"
      # user.image = auth.info.image.gsub("picture","picture?type=large") if user.provider == "facebook"
      # user.image = auth.info.image if user.provider == "google_oauth2"
    end
  end
end
