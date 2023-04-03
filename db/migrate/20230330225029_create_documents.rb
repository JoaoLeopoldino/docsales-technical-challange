class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents, id: :uuid do |t|
      t.text    :description,     null: false
      t.string  :customer_name,   null: false
      t.string  :contract_value,  null: false
      t.string  :template,        null: false

      t.timestamps
    end
  end
end
