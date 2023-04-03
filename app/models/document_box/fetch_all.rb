# frozen_string_literal: true

module DocumentBox
  class FetchAll < Micro::Case
    def call!
      documents = Document.order(created_at: :desc)

      Success(result: { data: DocumentBox::Serialize.collection_as_json(documents) })
    end
  end
end
