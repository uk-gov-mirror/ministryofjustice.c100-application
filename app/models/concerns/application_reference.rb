module ApplicationReference
  extend ActiveSupport::Concern

  class_methods do
    def find_by_reference_code(ref)
      year, month, uuid_part = ref.split('/')

      where(
        created_at: date_range(year, month)
      ).where(
        'id::text ILIKE :uuid_filter', uuid_filter: "#{uuid_part}%"
      ).take
    end

    def date_range(year, month)
      date = Date.new(year.to_i, month.to_i)
      [date.beginning_of_month..date.end_of_month]
    end
  end

  def reference_code
    @_reference_code ||= [date_token, uuid_token].join('/').upcase
  end

  private

  def date_token
    created_at.strftime('%Y/%m')
  end

  def uuid_token
    id.split('-').first
  end
end
