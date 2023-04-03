# frozen_string_literal: true

module DocumentBox
  class Serialize
    def self.as_json(document)
      {
        uuid: document.id,
        pdf_url: Rails.application.routes.url_helpers.api_v1_generate_pdf_document_url(document.id),
        description: document.description,
        document_data: {
          customer_name: document.customer_name,
          contract_value: document.contract_value
        },
        created_at: document.created_at
      }
    end

    def self.collection_as_json(documents)
      documents.map { |document| as_json(document) }
    end
  end
end
