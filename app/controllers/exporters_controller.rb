# Legacy exporter
class ExportersController < ApplicationController
  def show
    render xml: GpxExporter.export(params[:private].to_s == "true")
  end
end
