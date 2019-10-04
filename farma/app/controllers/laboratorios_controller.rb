class LaboratoriosController < ApplicationController
  def index
    @lista= Laboratorio.all
  end

  def new
    @laboratorio= Laboratorio.new
  end

  def create
    laboratorio=Laboratorio.new
    laboratorio.lab_desc=params[:laboratorio][:lab_desc]
    laboratorio.active=params[:laboratorio][:active]
    if laboratorio.save
      redirect_to laboratorios_index_path
    end
  end

  def edit
      @laboratorio= Laboratorio.find(params[:id])

  end

  def update
    laboratorio=Laboratorio.find(params[:laboratorio][:id])
    laboratorio.lab_desc=params[:laboratorio][:lab_desc]
    laboratorio.active=params[:laboratorio][:active]
    if laboratorio.save
      redirect_to laboratorios_index_path
    end

  end

  def delete
    laboratorio= Laboratorio.find(params[:id])
    if laboratorio.destroy
      redirect_to laboratorios_index_path
    end

  end
end
