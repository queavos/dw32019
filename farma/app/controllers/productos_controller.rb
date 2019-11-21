class ProductosController < ApplicationController
  before_action :authenticate_user!, except: [:delete, :index]

  def index
  #@lista= Producto.all
  #@lista= Producto.where(rubro_id: 2)
  #cond1= " rubro_id = 1"
  #cond2= "laboratorio_id = 1 "
  #cond3= cond1+" and "+cond2
 #cond3= " descripcion like '%ol' "
 #cond3 = "laboratorio_id IN (1,4) "
 cond3 = "laboratorio_id IN (?) ", [1,4]
  @lista= Producto.where(cond3)
  #@lista= Producto.where(laboratorio_id: [1,4])
  end

  def new
    @producto=Producto.new
  end

  def create
      producto=Producto.new
      producto.laboratorio_id=params[:producto][:laboratorio_id]
      producto.rubro_id=params[:producto][:rubro_id]
      producto.descripcion=params[:producto][:descripcion]
      producto.precio=params[:producto][:precio]
      producto.bcode=params[:producto][:bcode]
      producto.activo=params[:producto][:activo]
      if producto.save
        redirect_to productos_index_path
      end

  end

  def edit
    @producto=Producto.find(params[:id])

  end

  def update
    producto=Producto.find(params[:producto][:id])
    producto.laboratorio_id=params[:producto][:laboratorio_id]
    producto.rubro_id=params[:producto][:rubro_id]
    producto.descripcion=params[:producto][:descripcion]
    producto.precio=params[:producto][:precio]
    producto.bcode=params[:producto][:bcode]
    producto.activo=params[:producto][:activo]
    if producto.save
      redirect_to productos_index_path
    end
  end

  def delete
    producto=Producto.find(params[:id])
    if producto.destroy
      redirect_to productos_index_path
    end
  end
end
