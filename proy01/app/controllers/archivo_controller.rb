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
        redirect_to archivos_index_path
      else
        render "new"
      end
  end
  def edit
    @id=params[:id]
    @persona=Persona.find(@id)
  end
end
