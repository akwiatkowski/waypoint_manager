class ImportersController < ApplicationController
  def new
  end

  def create
    result = Importer.process_path(params[:path])
    flash[:notice] = "Processed path with #{result.size} waypoints"
    render 'new'
  end
end
