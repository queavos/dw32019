class CreatePersonas < ActiveRecord::Migration[5.2]
  def change
    create_table :personas do |t|
      t.string :nombres
      t.date :fecha
      t.string :pais

      t.timestamps
    end
  end
end
