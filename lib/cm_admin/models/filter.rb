module CmAdmin
  module Models
    class Filter
      attr_accessor :db_column_name, :filter_type, :placeholder, :collection, :multiselect, :checked

      VALID_FILTER_TYPES = Set[:checkbox, :date, :dropdown, :range, :search].freeze

      def initialize(db_column_name:, filter_type:, options: {})
        @name = db_column_name
        @type = filter_type.to_sym
        raise ArgumentError, "Kindly select a valid filter type like #{VALID_FILTER_TYPES.sort.to_sentence(last_word_connector: ', or ')} instead of #{filter_type} for column #{db_column_name}" unless VALID_FILTER_TYPES.include?(filter_type.to_sym)
        options.each do |key, value|
          self.send("#{key.to_s}=", value)
        end
      end
    end
  end
end