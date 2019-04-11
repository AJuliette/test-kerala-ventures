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

class Building < ApplicationRecord
  validates :reference, presence: true, uniqueness: true
  validates :address, presence: true
  validates :zip_code, presence: true
  validates :city, presence: true
  validates :country, presence: true
  validates :manager_name, presence: true
end
