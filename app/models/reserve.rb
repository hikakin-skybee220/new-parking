class Reserve < ApplicationRecord
    validates :start_on, reserve: true
    validates :finish_on, reserve: true
end
