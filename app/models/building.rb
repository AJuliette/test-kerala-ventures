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
end
