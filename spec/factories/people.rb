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

FactoryBot.define do
  factory :person do
  end
end
