class Park < ApplicationRecord
    validates :finish_on_schedule, presence: true
end
