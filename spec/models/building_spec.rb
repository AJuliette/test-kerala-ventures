# frozen_string_literal: true

# == Schema Information
#
# Table name: buildings
#
#  id           :bigint(8)        not null, primary key
#  reference    :string
#  address      :string
#  zip_code     :string
#  city         :string
#  country      :string
#  manager_name :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Building, type: :model do
  describe 'Model instantiation' do
    subject(:new_building) { described_class.new }

    describe 'Database of Item' do
      it { is_expected.to have_db_column(:id).of_type(:integer) }
      it { is_expected.to have_db_column(:reference).of_type(:string) }
      it { is_expected.to have_db_column(:address).of_type(:string) }
      it { is_expected.to have_db_column(:zip_code).of_type(:string) }
      it { is_expected.to have_db_column(:country).of_type(:string) }
      it { is_expected.to have_db_column(:manager_name).of_type(:string) }
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end
  end
end
