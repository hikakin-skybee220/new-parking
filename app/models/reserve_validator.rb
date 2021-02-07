class ReserveValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        # 新規登録する期間
        new_start_date = record.start_on
        new_finish_date   = record.finish_on

        return unless new_start_date.present? && new_finish_date.present?

        # 重複する期間を検索(編集時は自期間を除いて検索)
        if record.id.present?
            not_own_reserves = Reserve.where('id NOT IN (?) AND start_on <= ? AND finish_on >= ?', record.id, new_finish_date, new_start_date)
            not_own_reserves_by_park = Park.where('id NOT IN (?) AND start_on <= ? AND finish_on_schedule >= ?', record.id, new_finish_date, new_start_date)
        else
            not_own_reserves = Reserve.where('start_on <= ? AND finish_on >= ?', new_finish_date, new_start_date)
            not_own_reserves_by_park = Park.where('start_on <= ? AND finish_on_schedule >= ?', new_finish_date, new_start_date)
        end
        record.errors.add(attribute, 'に重複があります') if not_own_reserves.present? or not_own_reserves_by_park.present?        
    end
end