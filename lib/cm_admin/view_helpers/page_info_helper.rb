module CmAdmin
  module ViewHelpers
    module PageInfoHelper
      def page_title
        @action.title || @model.title || "#{@model.ar_model.name} | #{@action.name&.titleize} | Admin"
      end

      def action_title
        case action_name
        when 'index'
          @model.current_action.page_title || "#{@model.name} list record"
        when 'show'
          @model.current_action.page_title || "#{@model.name} detail"
        when 'new'
          @model.current_action.page_title || "#{@model.name} create record"
        when 'edit'
          @model.current_action.page_title || "#{@model.name} edit record"
        end
      end

      def action_description
        case action_name
        when 'index'
          @model.current_action.page_description || "#{@model.name} list record"
        when 'show'
          @model.current_action.page_description || "#{@model.name} detail"
        when 'new'
          @model.current_action.page_description || "#{@model.name} new record"
        when 'edit'
          @model.current_action.page_description || "#{@model.name} edit record"
        end
        
      end

      def page_url(action_name=@action.name, ar_object=nil)
        base_path = CmAdmin::Engine.mount_path + '/' + @model.name.downcase.pluralize
        case action_name
        when 'index'
          base_path
        when 'new'
          base_path + '/new'
        when 'edit'
          base_path + "/#{ar_object.id}" + '/edit'
        end
      end
    end
  end
end
