# frozen_string_literal: true

# == Schema Information
#
# Table name: people
#
#  id                  :bigint(8)        not null, primary key
#  reference           :string
#  email               :string
#  home_phone_number   :string
#  mobile_phone_number :string
#  firstname           :string
#  lastname            :string
#  address             :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

RSpec.describe Person, type: :model do
  describe 'Model instantiation' do
    subject(:person) { described_class.new }

    describe 'Database of Item' do
      it { is_expected.to have_db_column(:id).of_type(:integer) }
      it { is_expected.to have_db_column(:reference).of_type(:string) }
      it { is_expected.to have_db_column(:email).of_type(:string) }
      it { is_expected.to have_db_column(:home_phone_number).of_type(:string) }
      it { is_expected.to have_db_column(:mobile_phone_number).of_type(:string) }
      it { is_expected.to have_db_column(:firstname).of_type(:string) }
      it { is_expected.to have_db_column(:lastname).of_type(:string) }
      it { is_expected.to have_db_column(:address).of_type(:string) }
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end
  end

  context 'when testing validations' do
  end
end
