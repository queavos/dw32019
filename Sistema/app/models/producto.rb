class Producto < ApplicationRecord
  validates :rubro_id, presence: true
  validates :laboratorio_id, presence: true
  validates :prod_desc, presence: true
  validates :prod_activo, presence: true
validates :prod_precio, presence: true

# def laboratorio_nombre(id)
#   lab = Laboratorio.find(id)
#   lab.lab_desc
# end

  belongs_to :rubro
  belongs_to :laboratorio

  rails_admin do

    list  do
      field :rubro do
          pretty_value do
                bindings[:object].rubro.rubro_desc
          end

      end
      field :laboratorio do
          pretty_value do
                bindings[:object].laboratorio.lab_desc
          end

      end

      field :prod_desc do
        label 'Descripcion'
      end



      field :prod_precio do
        label 'Precio'
      end

      field :prod_activo do
        label 'Activo'
      end

    end

    edit do
      field :prod_desc do
        label 'Descripcion'
      end

      field :laboratorio_id, :enum do
        enum do
          Laboratorio.all.collect {|p| [p.lab_desc, p.id] }
        end
      end
      field :rubro_id, :enum do
        enum do
          Rubro.all.collect {|p| [p.rubro_desc, p.id] }
        end
      end

      field :prod_precio do
        label 'Precio'
      end

      field :prod_activo do
        label 'Activo'
      end
    end

  end

end
