# frozen_string_literal: true

FactoryBot.define do
  factory :document do
    description { Faker::Lorem.paragraph }
    document_data { { customer_name: Faker::Name.name, contract_value: Faker::Commerce.price } }
    template { '<p>Customer: {{customer_name}}<br>Contract value: {{contract_value}}</p>' }
  end
end
