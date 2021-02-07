class Park < ApplicationRecord
    validates :finish_on_schedule, presence: true
    validates :start_on, park: true
    validates :finish_on_schedule, park: true
end
