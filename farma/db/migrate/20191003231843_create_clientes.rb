class CreateClientes < ActiveRecord::Migration[5.2]
  def change
    create_table :clientes do |t|
      t.string :nombre
      t.string :ruc
      t.date :fecha
      t.integer :estado

      t.timestamps
    end
  end
end
