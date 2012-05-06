class ExportersController < ApplicationController
  def show
    render xml: GpxExporter.export
  end
end
