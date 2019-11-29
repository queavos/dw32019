class AddRecibemailToPersona < ActiveRecord::Migration[5.2]
  def change
    add_column :personas, :recibemail, :boolean
  end
end
