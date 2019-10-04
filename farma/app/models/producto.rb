class Producto < ApplicationRecord
  belongs_to :laboratorio
  belongs_to :rubro
end
