require 'cm_admin/model'

module CmAdmin
  class StaticController < ::ActionController::Base
    layout 'static'

    def dashboard
    end

    def error_403

    end

    # This method returns the columns in JSON format that are then pass to
    # javascript and stored in localStorage
    def hashed_columns
      pathname = params['pathname'].split('/')
      klass_name = pathname[0].singularize.titleize
      target_page = pathname.length > 1 ? :show : :index
      @model = CmAdmin::Model.find_by({name: klass_name})
      json_columns = @model.available_fields[target_page].to_json
      respond_to do |format|
        format.json {render json: json_columns }
      end
    end
  end
end
