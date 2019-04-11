# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Importer, type: :model do
  describe 'Parsing of CSV' do
  end

  describe 'Importer with one high level of update column' do
    before do
      file_building_day_1 = CSV.open('tmp/building_day_1.csv', 'w') do |csv|
        csv << %w[reference address zip_code city country manager_name]
        csv << ['1', '10 Rue La bruyère', '75009', 'Paris', 'France',	'Martin Faure']
        csv << ['2', '40 Rue René Clair', '75018', 'Paris', 'France',	'Martin Faure']
        csv << ['3', '40 Rue des Vinaigriers', '75011', 'Paris', 'France']
      end
      file_building_day_2 = CSV.open('tmp/building_day_2.csv', 'w') do |csv|
        csv << %w[reference address zip_code city country manager_name]
        csv << ['1', '10 Rue La bruyère', '75020', 'Paris', 'France',	'Martin Faure']
        csv << ['2', '40 Rue René Clair', '75018', 'Paris', 'Taïwan', 'Martin Building']
        csv << ['3', '40 Rue des Vinaigriers', '75011 Paris', 'France', 'Martin Martin']
      end
      Importer.import_from_csv(['manager_name'], 'tmp/building_day_1.csv', Building)
    end

    context 'when high level of update change' do
      before do
        Importer.import_from_csv(['manager_name'], 'tmp/building_day_2.csv', Building)
      end

      it "doesn't change attribute of high level update" do
        expect(Building.find_by(reference: 2).manager_name).to eq 'Martin Faure'
      end

      it 'does change other attributes of an object with a high level update' do
        expect(Building.find_by(reference: 2).country).to eq 'Taïwan'
      end
    end

    context "when there's a missing attribute in the csv" do
      it 'successfully imports the row' do
        expect(Building.all.count).to eq(3)
      end

      it 'update the attribute when the CSV file is update'
    end
  end

  describe 'Importer with several high level of update columns' do
  end
end
