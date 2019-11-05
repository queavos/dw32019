class Producto < ApplicationRecord
  belongs_to :rubro
  belongs_to :laboratorio
  rails_admin do

    list do
      fields :prod_desc do
        label 'Producto'
      end
      fields :prod_active do
        label 'Activo'
      end
      list do
        fields :prod_bcode do
          label 'Cod. Barra'
        end
        fields :prod_precio do
          label 'Precio'
        end
    end
    edit do
      fields :prod_desc do
        label 'Producto'
      end
      fields :laboratorio_id, :enum do
        enum do
        Laboratorio.all.collect{|p| [p.lab_desc, p.id]}
      end
      fields :laboratorio_id, :enum do
        enum do
        Rubro.all.collect{|p| [p.rubro_desc, p.id]}
      end
      end
      fields :prod_active do
        label 'Activo'
      end
      list do
        fields :prod_bcode do
          label 'Cod. Barra'
        end
        fields :prod_precio do
          label 'Precio'
        end
    end


  end
end
