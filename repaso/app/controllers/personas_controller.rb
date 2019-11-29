class PersonasController < ApplicationController
  def index
    @lista=Persona.all
  end

  def new
    @dato= Persona.new
  end

  def create
    dato=Persona.new
    dato.apellido=params[:dato][:apellido]
    dato.nombre=params[:dato][:nombre]
    dato.fenac=params[:dato][:fenac]
    dato.genero=params[:dato][:genero]
    dato.recibemail=params[:dato][:recibemail]
    dato.paise_id=params[:dato][:paise_id]
    if dato.save
      redirect_to personas_index_path
    end

  end

  def edit
    @dato=Persona.find(params[:id])



  end

  def update
    dato=Persona.find(params[:dato][:id])
    dato.apellido=params[:dato][:apellido]
    dato.nombre=params[:dato][:nombre]
    dato.fenac=params[:dato][:fenac]
    dato.genero=params[:dato][:genero]
    dato.recibemail=params[:dato][:recibemail]
      dato.paise_id=params[:dato][:paise_id]
    if dato.save
      redirect_to personas_index_path
    end

  end

  def delete
    dato=Persona.find(params[:id])
    if dato.destroy
      redirect_to personas_index_path
    end
  end
end
