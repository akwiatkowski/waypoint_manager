class ImportersController < ApplicationController
  def new
    authorize! :manage, Importer
    flash[:alert] = "It works only on localhost instance."
  end

  def create
    authorize! :manage, Importer

    result = Importer.process_path(params[:path], current_user)
    flash[:notice] = "Processed path with #{result.size} waypoints"
    render 'new'
  end
end
