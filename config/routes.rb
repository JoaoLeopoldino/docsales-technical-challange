Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'documents/list', to: 'documents#index', as: :documents_list
      match 'documents/create', to: 'documents#create', via: %i[post put], as: :create_and_update_documents
      get 'documents/:uuid/generate_pdf', to: 'documents#generate_pdf', as: :generate_pdf_document
    end
  end
end
