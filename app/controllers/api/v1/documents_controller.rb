# frozen_string_literal: true

module Api
  module V1
    class DocumentsController < ApplicationController
      def index
        DocumentBox::FetchAll
          .call
          .on_success { |result| render_json(:ok, result[:data]) }
      end

      def generate_pdf
        DocumentBox::GeneratePdf
          .call(params:)
          .on_failure(:document_not_found) { |result| render_json(422, error: result[:error]) }
          .on_success { |result| send_pdf_file(result[:data]) }
      end

      def create
        DocumentBox::Save::Flow
          .call(params:)
          .on_failure(:parameter_missing) { |result| render_json(400, message: result[:message]) }
          .on_failure(:invalid_document_params) { |result| render_json(422, errors: result[:errors]) }
          .on_success { |result| render_json(result[:status], result[:document]) }
      end

      private

      def send_pdf_file(data)
        send_data data[:pdf], filename: data[:filename], type: 'application/pdf'
      end
    end
  end
end
