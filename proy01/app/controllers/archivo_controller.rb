class ArchivoController < ApplicationController
    skip_before_action :verify_authenticity_token
  def index
    @personas=Persona.all
  end
  def new

  end
  def create
    @nombre=params[:nombre]
    @apellido=params[:apellido]
    @perso=Persona.new
    @perso.nombre=params[:nombre]
    @perso.apellido=params[:apellido]
     if   @perso.save
        redirect_to archivo_index_path
      else
        render "new"
      end
  end
  def edit
    @id=params[:id]
    @persona=Persona.find(@id)
  end
  def update
    @id=params[:id]
    @persona=Persona.find(@id)
    @persona.nombre=params[:nombre]
    @persona.apellido=params[:apellido]
    if   @persona.save
       redirect_to archivo_index_path
     else
       render "edit"
     end
  end
  def destroy
    @id=params[:id]
    @persona=Persona.find(@id)
    if   @persona.destroy
       redirect_to archivo_index_path
     else
       redirect_to archivo_index_path
     end

  end
end
