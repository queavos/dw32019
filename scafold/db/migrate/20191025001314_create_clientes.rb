class CreateClientes < ActiveRecord::Migration[5.2]
  def change
    create_table :clientes do |t|
      t.string :nombres
      t.date :fecha
      t.references :pais, foreign_key: true

      t.timestamps
    end
  end
end
