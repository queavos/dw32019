class ArchivoController < ApplicationController
    skip_before_action :verify_authenticity_token
  def index
  end

  def read
    @nombre=params[:nombre]
    @apellido=params[:apellido]
    @perso=Persona.new
    @perso.nombre=params[:nombre]
    @perso.apellido=params[:apellido]
    @perso.save
  end
end
