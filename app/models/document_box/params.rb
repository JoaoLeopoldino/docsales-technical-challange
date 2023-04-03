# frozen_string_literal: true

module DocumentBox
  class Params
    class << self
      def to_save(params)
        return params.permit(params_to_create) if params[:uuid].nil?

        params.permit(params_to_update)
      end

      private

      def params_to_create
        [
          :description,
          :template,
          { document_data: %i[customer_name contract_value] }
        ]
      end

      def params_to_update
        params_to_create << :uuid
      end
    end
  end
end
