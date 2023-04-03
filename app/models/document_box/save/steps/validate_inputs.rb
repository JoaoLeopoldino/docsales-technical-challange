# frozen_string_literal: true

module DocumentBox
  module Save
    module Steps
      class ValidateInputs < Micro::Case
        attributes :description, :document_data, :template

        def call!
          document = Document.new(document_attributes)

          return Success(result: attributes) if document.valid?

          Failure(:invalid_document_params, result: { errors: document.errors.messages })
        end

        private

        def document_attributes
          DocumentBox::Input.prepare_attributes(description, document_data, template)
        end
      end
    end
  end
end
