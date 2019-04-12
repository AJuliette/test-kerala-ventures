# frozen_string_literal: true

module Error
  module ImporterError
    def self.validate_imported_file(column_names, class_name_attributes)
      raise ArgumentError, 'invalid file' unless class_name_attributes.sort == column_names.sort
    end

    def self.validate_imported_records(references)
      raise IndexError, 'indexes not unique' unless references.size == references.uniq.size
    end

    def self.validate_high_level_update(high_level_of_updates, class_name)
      raise ArgumentError, "high level updates are not class' attributes" unless high_level_of_updates.to_set.subset?(class_name.attribute_names.to_set)
    end
  end
end
