class Rubro < ApplicationRecord

rails_admin do
  list  do
    #label 'Lista'
    field :rubro_desc do
      label 'Descripcion'
    end

    field :rubro_iva do
      label 'Iva'
    end

  end

  edit do
    field :rubro_desc do
      label 'Descripcion'
    end

    field :rubro_iva do
      label 'Iva'
    end
  end

end

end
