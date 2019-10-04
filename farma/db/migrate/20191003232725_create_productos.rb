class CreateProductos < ActiveRecord::Migration[5.2]
  def change
    create_table :productos do |t|
      t.string :descripcion
      t.float :precio
      t.boolean :activo
      t.string :bcode
      t.references :laboratorio, foreign_key: true
      t.references :rubro, foreign_key: true

      t.timestamps
    end
  end
end
