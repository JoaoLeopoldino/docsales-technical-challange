# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Documents::Create' do
  let(:pdf_template_directory_path) { Rails.root.join('app/views/layouts/pdf_templates') }

  let(:valid_params) { attributes_for(:document) }
  let(:invalid_params) do
    {
      description: nil,
      document_data: { customer_name: nil, contract_value: nil },
      template: nil
    }
  end
  let(:missing_params) { { document_data: nil } }

  describe 'POST /api/v1/documents/create' do
    context 'when the params are valid' do
      before do
        post api_v1_create_and_update_documents_url, params: valid_params, as: :json
      end

      after do
        document = Document.last
        pdf_template_file = "#{pdf_template_directory_path}/#{document.template}"

        FileUtils.rm(pdf_template_file) if File.exist?(pdf_template_file)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(:created)
      end

      it 'returns the json for created document' do
        document = Document.last

        expect(json[:uuid]).to eq(document.id)
        expect(json[:pdf_url]).to eq(Rails.application.routes.url_helpers.api_v1_generate_pdf_document_url(document.id))
        expect(json[:description]).to eq(document.description)
        expect(json[:document_data][:customer_name]).to eq(document.customer_name)
        expect(json[:document_data][:contract_value]).to eq(document.contract_value)
        expect(json[:created_at]).to_not eq(nil)
      end

      it 'pdf template file is created' do
        document = Document.last
        pdf_template_file = "#{pdf_template_directory_path}/#{document.template}"
        expect(File).to exist(pdf_template_file)
      end
    end

    context 'when the params are invalid' do
      before do
        post api_v1_create_and_update_documents_url, params: invalid_params, as: :json
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns errors in json format' do
        expect(json[:errors]).to have_key(:description)
        expect(json[:errors]).to have_key(:customer_name)
        expect(json[:errors]).to have_key(:contract_value)
        expect(json[:errors]).to have_key(:template)
      end
    end

    context 'when missing params' do
      before do
        post api_v1_create_and_update_documents_url, params: missing_params, as: :json
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
