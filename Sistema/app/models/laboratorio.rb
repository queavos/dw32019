class Laboratorio < ApplicationRecord

rails_admin do
   list  do
     field :lab_desc do
       label 'Descripcion'
     end
     field :lab_active do
       label 'Descripcion'
     end
end

edit do
  field :lab_desc do
    label 'Descripcion'
  end

  field :lab_active do
    label 'Activo'
  end
end

end

end
