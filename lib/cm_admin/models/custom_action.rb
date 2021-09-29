require_relative 'actions/blocks'

module CmAdmin
  module Models
    class CustomAction < Action
      class << self
        def find_by(model, search_hash)
          model.available_actions.find { |i| i.name == search_hash[:name] }
        end
      end
    end
  end
end
