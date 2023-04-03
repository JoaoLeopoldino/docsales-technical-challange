# frozen_string_literal: true

module DocumentBox
  module Save
    class Flow < Micro::Case
      flow Steps::NormalizeParams,
           Steps::ValidateInputs,
           Steps::LoadDocumentFromDatabase,
           Steps::CreatePdfTemplateFile,
           Steps::SaveDocument
    end
  end
end
