# frozen_string_literal: true

module DocumentBox
  module Save
    module Steps
      class NormalizeParams < Micro::Case
        attribute :params

        def call!
          Success result: normalized_params
        rescue ActionController::ParameterMissing => e
          Failure(:parameter_missing, result: { message: e.message })
        end

        private

        def normalized_params
          document_params = DocumentBox::Params.to_save(params)

          data = build_body(document_params)

          data = data.merge({ uuid: document_params[:uuid] }) if document_params[:uuid].present?
          data
        end

        def build_body(document_params)
          {
            description: document_params&.fetch(:description)&.strip,
            document_data: {
              customer_name: document_params&.fetch(:document_data)&.fetch(:customer_name)&.strip,
              contract_value: document_params&.fetch(:document_data)&.fetch(:contract_value)
            },
            template: document_params&.fetch(:template)&.strip
          }
        end
      end
    end
  end
end
