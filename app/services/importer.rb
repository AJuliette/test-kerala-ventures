# frozen_string_literal: true

require 'csv'
require 'pry'

class Importer < ActiveRecord::Base
  def self.create_array_of_attributes(file_path)
    record_attributes = []
    CSV.foreach(file_path, headers: true) do |row|
      record_attributes << clean_csv(row.to_hash)
    end
    record_attributes
  end

  def self.clean_csv(hash)
    hash.each { |k, v| v.blank? ? hash[k] = 'nil' : nil }
    hash
  end

  def self.get_objects(class_name, record_attributes)
    records = []
    record_attributes.each do |attr|
      records << class_name.new(attr)
    end
    records
  end

  def self.import_from_csv(high_level_of_updates, file_path, class_name)
    record_attributes = create_array_of_attributes(file_path)
    records = get_objects(class_name, record_attributes)
    column_names = CSV.open(file_path, &:readline)
    low_level_of_update_columns = (column_names - high_level_of_updates - ['reference']).map(&:to_sym)
    class_name.import records, on_duplicate_key_update: {
      conflict_target: [:reference],
      columns: low_level_of_update_columns,
      validate: false
    }
    import_high_level_of_update(high_level_of_updates, class_name, records)
  end

  def self.import_high_level_of_update(high_level_of_updates, class_name, records)
    high_level_of_updates.each do |high_level_column_name|
      class_name.import records, on_duplicate_key_update: {
        conflict_target: [:reference],
        columns: [:"#{high_level_column_name}"],
        condition: "(#{class_name.table_name}.#{high_level_column_name} <> '') IS NOT TRUE",
        validate: false
      }
    end
  end
end
