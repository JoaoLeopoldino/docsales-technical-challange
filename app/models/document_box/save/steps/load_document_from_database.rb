# frozen_string_literal: true

module DocumentBox
  module Save
    module Steps
      class LoadDocumentFromDatabase < Micro::Case
        attribute :uuid

        def call!
          document_record = Document.find(uuid) if uuid.present?

          Success(result: { document_record: })
        rescue ActiveRecord::RecordNotFound => e
          Failure(:record_not_found, result: { message: e.message })
        end
      end
    end
  end
end
