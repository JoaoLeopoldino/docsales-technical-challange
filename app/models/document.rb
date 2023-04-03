# frozen_string_literal: true

class Document < ApplicationRecord
  validates :description, :customer_name, :contract_value, :template, presence: true
end
