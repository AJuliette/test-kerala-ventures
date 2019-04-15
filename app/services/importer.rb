# frozen_string_literal: true

require 'csv'

class Importer
  def self.prepare_records(klass, file_path)
    records = CSV.foreach(file_path, headers: true).map do |row|
      klass.new(row.to_hash)
    end
    check_records(records)
    records
  end

  def self.check_records(records)
    Error::ImporterError.validate_imported_records(records.pluck(:reference))
  end

  def self.import_from_csv(high_level_of_updates, file_path, klass)
    Error::ImporterError.validate_high_level_update(high_level_of_updates, klass)

    records = prepare_records(klass, file_path)

    column_names = CSV.open(file_path, &:readline)
    low_level_of_update_columns = (column_names - high_level_of_updates - ['reference']).map(&:to_sym)

    klass.import records, on_duplicate_key_update: { conflict_target: [:reference], columns: low_level_of_update_columns, validate: false }

    import_high_level_of_update(high_level_of_updates, klass, records)
  end

  def self.import_high_level_of_update(high_level_of_updates, klass, records)
    # Pas sur de comprendre en quoi ca resoud notre probleme, on ne checke pas par rapport aux anciens
    high_level_of_updates.each do |high_level_column_name|
      klass.import records, on_duplicate_key_update: {
        conflict_target: [:reference],
        columns: [high_level_column_name.to_sym],
        condition: "(#{klass.table_name}.#{high_level_column_name} <> '') IS NOT TRUE", # Complexe, il faudrait un commentaire pour expliquer
        validate: false
      }
    end
  end
end
