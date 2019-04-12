# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Importer, type: :model do
  before do
    CSV.open('tmp/building_day_1.csv', 'w') do |csv|
      csv << %w[reference address zip_code city country manager_name]
      csv << ['1', '10 Rue La bruyère', '75009', 'Paris', 'France',	'Martin Faure']
      csv << ['2', '40 Rue René Clair', '75018', 'Paris', 'France',	'Martin Faure']
      csv << ['3', '40 Rue des Vinaigriers', '75011', 'Paris', 'France']
    end
    CSV.open('tmp/building_day_2.csv', 'w') do |csv|
      csv << %w[reference address zip_code city country manager_name]
      csv << ['1', '10 Rue de la Felicità', '30000', 'Nîmes', 'Espagne',	'Martin Faure']
      csv << ['2', '40 Rue René Clair', '75018', 'Paris', 'Taïwan', 'Martin Building']
      csv << ['3', '40 Rue des Vinaigriers', '75011', 'Paris', 'Italie', 'Martin Martin']
    end

    CSV.open('tmp/people_day_1.csv', 'w') do |csv|
      csv << %w[reference firstname lastname home_phone_number mobile_phone_number email address]
      csv << ['1', 'Henri', 'Dupont',	'0123456789', '0623456789', 'h.dupont@gmail.com', '10 Rue La bruyère']
      csv << ['2', 'Jean', 'Durand', '0123336789', '0663456789',	'jdurand@gmail.com', '40 Rue René Clair']
    end
    CSV.open('tmp/people_day_2.csv', 'w') do |csv|
      csv << %w[reference firstname lastname home_phone_number mobile_phone_number email address]
      csv << ['1', 'Jacques', 'Duchaussée',	'0123456790', '0623456790', 'h.duchaussée@gmail.com', '10 Rue Montaigne']
      csv << ['2', 'Jean', 'Durand', '0123336789', '0663456789',	'jdurand@gmail.com', '40 Rue René Clair']
    end

    CSV.open('tmp/falsy_file.csv', 'w') do |csv|
      csv << %w[reference address zip_code city country manager_name]
      csv << ['1', '10 Rue La bruyère', '75009', 'Paris', 'France',	'Martin Faure']
      csv << ['2', '40 Rue René Clair', '75018', 'Paris', 'France',	'Martin Faure']
      csv << ['3', '40 Rue des Vinaigriers', '75011', 'Paris', 'France']
      csv << ['3', '40 Rue des Vinaigriers', '75011', 'Paris', 'France']
    end

    Importer.import_from_csv(['manager_name'], 'tmp/building_day_1.csv', Building)
    Importer.import_from_csv(%w[email home_phone_number mobile_phone_number address], 'tmp/people_day_1.csv', Person)
  end

  describe 'Parsing of CSV' do
    context "when there's a missing attribute in the csv" do
      it 'successfully imports the row' do
        expect(Building.all.count).to eq(3)
      end

      it 'gives the value nil to the missing attribute' do
        expect(Building.find_by(reference: 3).manager_name).to eq nil
      end
    end
  end

  describe 'Updating of a high level of update in the csv file' do
    before do
      Importer.import_from_csv(['manager_name'], 'tmp/building_day_2.csv', Building)
    end

    context 'when the field is not nil in the database' do
      it "doesn't change attribute of high level update" do
        expect(Building.find_by(reference: 2).manager_name).to eq 'Martin Faure'
      end

      it 'does change other attributes' do
        expect(Building.find_by(reference: 2).country).to eq 'Taïwan'
      end
    end

    context 'when the field is nil in the database' do
      it 'updates the attribute' do
        expect(Building.find_by(reference: 3).manager_name).to eq 'Martin Martin'
      end

      it 'does change other attributes' do
        expect(Building.find_by(reference: 3).country).to eq 'Italie'
      end
    end
  end

  describe 'Updating of non high level of update fields in the csv file' do
    before do
      Importer.import_from_csv(['manager_name'], 'tmp/building_day_2.csv', Building)
    end

    it 'does update the address' do
      expect(Building.find_by(reference: 1).address).to eq '10 Rue de la Felicità'
    end

    it 'does update the zip_code' do
      expect(Building.find_by(reference: 1).zip_code).to eq '30000'
    end

    it 'does update the city' do
      expect(Building.find_by(reference: 1).city).to eq 'Nîmes'
    end

    it 'does update the country' do
      expect(Building.find_by(reference: 1).country).to eq 'Espagne'
    end

    it "doesn't change the high level of update field" do
      expect(Building.find_by(reference: 1).manager_name).to eq 'Martin Faure'
    end
  end

  describe 'Importer with several high level of update columns' do
    context 'when several high level of update are updated in the csv file' do
      before do
        Importer.import_from_csv(%w[email home_phone_number mobile_phone_number address], 'tmp/people_day_2.csv', Person)
      end

      it "doesn't update the high level of update column email" do
        expect(Person.find_by(reference: 1).email).to eq 'h.dupont@gmail.com'
      end

      it "doesn't update the high level of update column home phone number" do
        expect(Person.find_by(reference: 1).home_phone_number).to eq '0123456789'
      end

      it "doesn't update the high level of update column mobile phone number" do
        expect(Person.find_by(reference: 1).mobile_phone_number).to eq '0623456789'
      end

      it "doesn't update the high level of update column address" do
        expect(Person.find_by(reference: 1).address).to eq '10 Rue La bruyère'
      end

      it 'updates other attribute firstname' do
        expect(Person.find_by(reference: 1).firstname).to eq 'Jacques'
      end

      it 'updates other attribute lastname' do
        expect(Person.find_by(reference: 1).lastname).to eq 'Duchaussée'
      end
    end
  end

  describe 'Raising of exceptions' do
    context "when the file column names don't correspond to the class attributes" do

      it 'raises an argument error' do
        expect{ Importer.import_from_csv(['manager_name'], 'tmp/people_day_2.csv', Building)}.to raise_error(ArgumentError)
      end
    end

    context "when references'indexes are not unique" do

      it 'raises an index error' do
        expect{ Importer.import_from_csv(['manager_name'], 'tmp/falsy_file.csv', Building)}.to raise_error(IndexError)
      end
    end

    context 'when wrong high level updates are passed as arguments' do

      it 'raises an argument error' do
        expect{ Importer.import_from_csv(['manager_name'], 'tmp/people_day_2.csv', Person)}.to raise_error(ArgumentError)
      end
    end

    context "when there's no reason to raise error" do

      it "doesn't raise an error" do
        expect{ Importer.import_from_csv(['manager_name'], 'tmp/building_day_1.csv', Building) }.not_to raise_error
      end
    end
  end
end
