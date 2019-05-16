module C100App
  class MapAddressLookupResults
    LINE_ONE_PARTS = %w[SUB_BUILDING_NAME BUILDING_NUMBER BUILDING_NAME].freeze
    LINE_TWO_PARTS = %w[DEPENDENT_THOROUGHFARE_NAME THOROUGHFARE_NAME].freeze
    COUNTRY_NAME = "United Kingdom".freeze

    Address = Struct.new(:address_line_1, :address_line_2, :town, :country, :postcode) do
      def address_lines
        [address_line_1, address_line_2].join(', ')
      end

      def tokenized_value
        values.join('|')
      end
    end

    def self.call(results)
      results.map do |result|
        map_to_address(result.fetch('DPA'))
      end
    end

    def self.map_to_address(result)
      Address.new(
        address_line(result.slice(*LINE_ONE_PARTS).values),
        address_line(result.slice(*LINE_TWO_PARTS).values),
        result.fetch('POST_TOWN'),
        COUNTRY_NAME,
        result.fetch('POSTCODE')
      )
    end

    def self.address_line(values)
      values.reject(&:blank?).join(', ')
    end
  end
end
