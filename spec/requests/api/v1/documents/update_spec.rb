# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Documents::Update' do
  let(:customer_name) { Faker::Name.name }
  let(:contract_value) { Faker::Commerce.price }
  let(:template) { '<p>Customer: {{customer_name}}<br>Contract value: {{contract_value}}</p>' }

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

  let(:valid_params) do
    {
      uuid: document.id,
      description: 'Change description',
      document_data: { customer_name: document.customer_name, contract_value: document.contract_value },
      template:
    }
  end

  let(:invalid_params) do
    {
      uuid: document.id,
      description: nil,
      document_data: { customer_name: document.customer_name, contract_value: document.contract_value },
      template:
    }
  end
  let(:missing_params) { { document_data: nil } }

  describe 'PUT /api/v1/documents/create' do
    context 'when the params are valid' do
      before do
        put api_v1_create_and_update_documents_url, params: valid_params, as: :json
      end

      after do
        document.reload
        pdf_template_file = "#{pdf_template_directory_path}/#{pdf_template_name}"
        new_pdf_template_file = "#{pdf_template_directory_path}/#{document.template}"

        FileUtils.rm(pdf_template_file) if File.exist?(pdf_template_file)
        FileUtils.rm(new_pdf_template_file) if File.exist?(new_pdf_template_file)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the json for updated document' do
        expect(json[:uuid]).to eq(document.id)
        expect(json[:pdf_url]).to eq(Rails.application.routes.url_helpers.api_v1_generate_pdf_document_url(document.id))
        expect(json[:description]).to eq(valid_params[:description])
        expect(json[:document_data][:customer_name]).to eq(document.customer_name)
        expect(json[:document_data][:contract_value]).to eq(document.contract_value)
        expect(json[:created_at]).to_not eq(nil)
      end

      it 'pdf template file is created' do
        document.reload
        expect(File).to exist("#{pdf_template_directory_path}/#{document.template}")
      end
    end

    context 'when the params are invalid' do
      before do
        post api_v1_create_and_update_documents_url, params: invalid_params, as: :json
      end

      after do
        pdf_template_file = "#{pdf_template_directory_path}/#{pdf_template_name}"
        FileUtils.rm(pdf_template_file) if File.exist?(pdf_template_file)
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns errors in json format' do
        expect(json[:errors]).to have_key(:description)
      end
    end

    context 'when missing params' do
      before do
        post api_v1_create_and_update_documents_url, params: missing_params, as: :json
      end

      after do
        pdf_template_file = "#{pdf_template_directory_path}/#{pdf_template_name}"
        FileUtils.rm(pdf_template_file) if File.exist?(pdf_template_file)
      end

      it 'returns status code 400' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns message error' do
        expect(json[:message]).to eq('param is missing or the value is empty: description')
      end
    end
  end
end
