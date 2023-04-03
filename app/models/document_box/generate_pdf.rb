# frozen_string_literal: true

module DocumentBox
  class GeneratePdf < Micro::Case
    attribute :params

    def call!
      @document = Document.find(document_id)

      Success(result: { data: generate_pdf })
    rescue ActiveRecord::RecordNotFound => e
      Failure(:document_not_found, result: { error: e.message })
    end

    private

    def document_id
      params[:uuid].strip
    end

    def pdf_template_directory_path
      Rails.root.join('app/views/layouts/pdf_templates')
    end

    def pdf_template_file
      "#{pdf_template_directory_path}/#{@document.template}"
    end

    def generate_filename
      "#{@document.template.split('.').first}.pdf"
    end

    def generate_pdf
      grover = Grover.new(File.read(pdf_template_file), format: 'A4')

      {
        pdf: grover.to_pdf,
        filename: generate_filename
      }
    end
  end
end
