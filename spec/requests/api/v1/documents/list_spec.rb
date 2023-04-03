# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Documents::List' do
  let(:customer_name) { Faker::Name.name }
  let(:contract_value) { Faker::Commerce.price }

  let(:pdf_template_directory_path) { Rails.root.join('app/views/layouts/pdf_templates') }
  let(:pdf_template_name) { "#{Random.hex}.html" }
  let(:pdf_template_content) { "<p>Customer: #{customer_name}<br>Contract value: #{contract_value}</p>" }
  let!(:pdf_template_file) do
    File.write("#{pdf_template_directory_path}/#{pdf_template_name}", pdf_template_content)
  end

  let!(:document) do
    Document.create({
                      template: pdf_template_name,
                      description: Faker::Lorem.paragraph,
                      customer_name:,
                      contract_value:
                    })
  end

  describe 'GET /api/v1/documents/list' do
    before do
      get api_v1_documents_list_url, as: :json
    end

    after do
      FileUtils.rm_rf("#{pdf_template_directory_path}/#{pdf_template_name}")
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the json data' do
      expect(json.first).to have_key(:uuid)
      expect(json.first).to have_key(:pdf_url)
      expect(json.first).to have_key(:description)
      expect(json.first).to have_key(:document_data)
      expect(json.first).to have_key(:created_at)
    end
  end
end
