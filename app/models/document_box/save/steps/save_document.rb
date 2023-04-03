# frozen_string_literal: true

module DocumentBox
  module Save
    module Steps
      class SaveDocument < Micro::Case
        attributes :description, :document_data, :template, :document_record

        def call!
          if document_record.nil?
            document = Document.create(document_attributes)
            Success result: { document: serialized_data(document), status: :created } if document.persisted?
          elsif document_record.update(document_attributes)
            Success result: { document: serialized_data(document_record),
                              status: :ok }
          end
        end

        private

        def document_attributes
          DocumentBox::Input.prepare_attributes(description, document_data, template)
        end

        def serialized_data(document)
          DocumentBox::Serialize.as_json(document)
        end
      end
    end
  end
end
