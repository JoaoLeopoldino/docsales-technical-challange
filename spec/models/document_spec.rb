# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Document, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:customer_name) }
    it { is_expected.to validate_presence_of(:contract_value) }
    it { is_expected.to validate_presence_of(:template) }
  end
end
