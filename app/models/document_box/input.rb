# frozen_string_literal: true

module DocumentBox
  class Input
    def self.prepare_attributes(description, document_data, template)
      {
        description:,
        customer_name: document_data&.fetch(:customer_name),
        contract_value: document_data&.fetch(:contract_value),
        template:
      }
    end
  end
end
