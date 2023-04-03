# frozen_string_literal: false

require 'rails_helper'

RSpec.describe DocumentBox::Save::Steps::CreatePdfTemplateFile, type: :use_case do
  describe '.call' do
    let(:pdf_template_directory_path) { Rails.root.join('app/views/layouts/pdf_templates') }

    let(:document_data) { { customer_name: 'John Doe', contract_value: 'R$ 3.500,00' } }
    let(:template) { '<p>Customer: {{customer_name}}<br>Contract value: {{contract_value}}</p>' }

    it 'returns a successful result' do
      result = described_class.call(document_data:, template:)
      expect(result).to be_a_success

      pdf_template_file = "#{pdf_template_directory_path}/#{result.data[:template]}"
      expected_content = '<p>Customer: John Doe<br>Contract value: R$ 3.500,00</p>'
      expect(File.read(pdf_template_file)).to eq(expected_content)

      FileUtils.rm_rf(pdf_template_file) if File.exist?(pdf_template_file)
    end
  end
end
