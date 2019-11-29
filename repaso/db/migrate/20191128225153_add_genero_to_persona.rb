class AddGeneroToPersona < ActiveRecord::Migration[5.2]
  def change
    add_column :personas, :genero, :string
  end
end
