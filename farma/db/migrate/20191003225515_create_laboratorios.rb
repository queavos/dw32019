class CreateLaboratorios < ActiveRecord::Migration[5.2]
  def change
    create_table :laboratorios do |t|
      t.string :lab_desc
      t.integer :active
      t.timestamps
    end
  end
end
