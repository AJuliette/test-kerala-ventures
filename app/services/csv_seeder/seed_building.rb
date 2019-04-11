# frozen_string_literal: true

require 'csv'

module CsvSeeder
  class SeedBuilding
    def call
      CSV.open('db/building.csv', 'wb') do |csv|
        csv << %w[reference address zip_code city country manager_name]
        10_000.times do |i|
          csv << [(i + 1).to_s, "#{i + 1} Maddison Avenue", 'NY 10029', 'New York', 'USA', "Manager#{i + 1}"]
        end
      end
    end

    def self.perform
      CsvSeeder::SeedBuilding.new.call
      puts 'Building seeded'
    end
  end
end

CsvSeeder::SeedBuilding.perform
