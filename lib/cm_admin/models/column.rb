module CmAdmin
  module Models
    class Column
      attr_accessor :field_name, :field_type, :header, :format, :prefix, :suffix, :exportable, :round,
      :cm_css_class, :link, :url, :custom_method, :helper_method, :managable, :lockable, :sortable, :sort_direction

      VALID_SORT_DIRECTION = Set[:asc, :desc].freeze

      def initialize(field_name, attributes = {})
        @field_name = field_name
        set_default_values
        attributes.each do |key, value|
          self.send("#{key.to_s}=", value)
        end

        #formatting header (either field_name or value present in header attribute)
        self.send("header=", format_header)
        set_sort_columns
      end

      #returns a string value as a header (either field_name or value present in header attribute)
      def format_header
        self.header.present? ? self.header.to_s.gsub(/_/, ' ')&.upcase : self.field_name.to_s.gsub(/_/, ' ').upcase
      end

      def set_default_values
        self.exportable = true
        self.managable = true
        self.lockable = false
        self.sortable = false
      end

      def set_sort_columns
        if self.sort_direction.present?
          raise ArgumentError, "Kindly select a valid sort direction like #{VALID_SORT_DIRECTION.join(' or ')} instead of #{self.sort_direction} for column #{self.field_name}" unless VALID_SORT_DIRECTION.include?(self.sort_direction.to_sym.downcase)
          self.sortable = true
          self.sort_direction = self.sort_direction.to_s
        end
        self.sort_direction = 'asc' if self.sortable && !self.sort_direction
      end

      #formatting value for different data types
      def self.format_data_type(column, value)
        case column.column_type
        when :string
          if column.format.present?
            column.format = [column.format] if column.format.is_a? String
            column.format.each do |formatter|
              value = value.send(formatter)
            end
          end
        when :datetime
          format_value = column.format.present? ? column.format.to_s : '%d/%m/%Y'
          value = value.strftime(format_value)
        when :enum
          value = value.titleize
        when :decimal
          round_to = column.round.present? ? column.round.to_i : 2
          value = value.round(round_to)
        when :custom

        end
        return value
      end

      class << self
        def find_by(model, search_hash)
          model.available_fields.find { |i| i.name == search_hash[:name] }
        end
      end

    end
  end
end
