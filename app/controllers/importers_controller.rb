class ImportersController < ApplicationController
  def new
    authorize! :manage, Importer
  end

  def create
    authorize! :manage, Importer

    result = Importer.process_path(params[:path])
    flash[:notice] = "Processed path with #{result.size} waypoints"
    render 'new'
  end
end
