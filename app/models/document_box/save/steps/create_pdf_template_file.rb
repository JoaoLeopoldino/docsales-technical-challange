# frozen_string_literal: true

module DocumentBox
  module Save
    module Steps
      class CreatePdfTemplateFile < Micro::Case
        attributes :document_data, :template, :document_record

        def call!
          replace_placeholders_with_document_data!
          generate_pdf_template_name!
          delete_previous_pdf_template_file! if document_record.present?
          create_pdf_template_folder!
          create_pdf_template_file!

          Success result: { template: @template_name }
        end

        private

        def replace_placeholders_with_document_data!
          document_data.each do |data|
            template.gsub!("{{#{data[0]}}}", data[1].to_s)
          end
        end

        def generate_pdf_template_name!
          @template_name = "#{Random.hex}.html"
        end

        def delete_previous_pdf_template_file!
          previous_pdf_template_file = "#{pdf_template_directory_path}/#{document_record.template}"

          FileUtils.rm(previous_pdf_template_file) if File.exist?(previous_pdf_template_file)
        end

        def create_pdf_template_folder!
          FileUtils.mkdir(pdf_template_directory_path) unless Dir.exist?(pdf_template_directory_path)
        end

        def create_pdf_template_file!
          File.write("#{pdf_template_directory_path}/#{@template_name}", template)
        end

        def pdf_template_directory_path
          Rails.root.join('app/views/layouts/pdf_templates')
        end
      end
    end
  end
end
