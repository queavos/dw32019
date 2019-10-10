class RubrosController < ApplicationController
  def index
    @datos= Rubro.all
  end

  def new
    @dato= Rubro.new
  end

  def create
    dato=Rubro.new
    dato.rubro_desc=params[:dato][:rubro_desc]
    dato.rubro_iva=params[:dato][:rubro_iva]
    if dato.save
      redirect_to rubros_index_path
    end
  end

  def edit
      @dato= Rubro.find(params[:id])

  end

  def update
    dato=Rubro.find(params[:dato][:id])
    dato.rubro_desc=params[:dato][:rubro_desc]
    dato.rubro_iva=params[:dato][:rubro_iva]
    if dato.save
      redirect_to rubros_index_path
    end

  end

  def delete
    dato= Rubro.find(params[:id])
    if dato.destroy
      redirect_to rubros_index_path
    end

  end
end
