class User < ApplicationRecord
    has_one :card, dependent: :destroy
    validates :email, presence: true
    validates :uid, presence: true
end
