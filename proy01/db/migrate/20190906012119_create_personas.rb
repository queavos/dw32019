class CreatePersonas < ActiveRecord::Migration[5.2]
  def change
    create_table :personas do |t|
      t.string :apellido
      t.string :nombre

      t.timestamps
    end
  end
end
