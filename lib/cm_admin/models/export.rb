module CmAdmin
  module Models
    class Export
      class << self
        def generate_excel(klass_name, params, helpers)
          klass = klass_name.constantize
          columns = params[:columns] || []
          # filter_params = params[:filters]
          model = CmAdmin::Model.find_by({name: klass_name})
          # records = get_records(klass, model, columns, helpers)
          records = "CmAdmin::#{klass_name}Policy::Scope".constantize.new(Current.user, klass).resolve
          filtered_data = CmAdmin::Models::Filter.filtered_data(model.filter_params(params), records, model.filters)
          formatted_data = format_records(filtered_data, model, columns, helpers)
          file_path = "#{Rails.root}/tmp/#{klass}_data_#{DateTime.now.strftime("%Y-%m-%d_%H-%M-%S")}.xlsx"
          create_workbook(formatted_data, columns, file_path)
          return file_path
        end


        def format_records(records, model, columns, helpers)
          custom_fields = model.available_fields[:index].map{|field| field if field.field_type == :custom}.compact
          normal_fields = model.available_fields[:index].map{|field| field unless field.field_type == :custom}.compact
          deserialized_columns = CmAdmin::Utils.deserialize_csv_columns(columns, :as_json_params)
          # This includes isn't recursve, a full solution should be recursive
          records_arr = []
          records.includes(deserialized_columns[:include].keys).find_each do |record|
            record_hash = record.as_json({only: columns.map(&:to_sym)})
            columns.each do |column|
              break unless model.available_fields[:index].map(&:field_name).include?(column.to_sym)
              record_hash[column.to_sym] = record.send(column.to_sym)
            end
            custom_fields.each do |field|
              record_hash[field.field_name.to_sym] = helpers.send(field.helper_method, record, field.field_name)
            end
            records_arr << record_hash
          end
          records_arr
        end

        def create_workbook(records, class_name, file_path)
          flattened_records = records.map { |record| CmAdmin::Utils.flatten_hash(record) }
          columns = flattened_records.map{|x| x.keys}.flatten.uniq.sort
          size_arr = []
          columns.size.times { size_arr << 22 }
          xl = Axlsx::Package.new
          xl.workbook.add_worksheet do |sheet|
            sheet.add_row columns&.map(&:titleize), b: true
            flattened_records.each do |record|
              sheet.add_row(columns.map { |column| record[column] })
            end
          sheet.column_widths(*size_arr)
          end
          xl.serialize(file_path)
        end

        def exportable_columns(klass)
          klass.available_fields[:index].map{|x| x.exportable ? x.field_name : ""}.reject { |c| c.empty? }
        end

      end
    end
  end
end
