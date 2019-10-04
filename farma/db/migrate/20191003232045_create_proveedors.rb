class CreateProveedors < ActiveRecord::Migration[5.2]
  def change
    create_table :proveedors do |t|
      t.string :nombre
      t.string :ruc
      t.string :telefono
      t.text :direcccion
      t.string :mail

      t.timestamps
    end
  end
end
