# frozen_string_literal: true

require 'csv'

module CsvSeeder
  class SeedPeople
    def call
      CSV.open('db/people.csv', 'wb') do |csv|
        csv << %w[reference firstname lastname home_phone_number mobile_phone_number email address]
        10_000.times do |i|
          csv << [(i + 1).to_s, "Firstname#{i + 1}", "Lastname#{i + 1}", '0180992103', '0666266959', "email#{i + 1}@email.com", 'address']
        end
      end
    end

    def self.perform
      CsvSeeder::SeedPeople.new.call
      puts 'People seeded'
    end
  end
end

# Bizarre, pourquoi appeler perform ici ?
CsvSeeder::SeedPeople.perform
