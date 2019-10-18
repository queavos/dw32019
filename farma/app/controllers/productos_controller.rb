class ProductosController < ApplicationController
  before_action :authenticate_user!, except: [:delete, :index]

  def index
  @lista= Producto.all

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
