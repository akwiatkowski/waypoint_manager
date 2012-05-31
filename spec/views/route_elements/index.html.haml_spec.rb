require 'spec_helper'

describe "route_elements/index" do
  before(:each) do
    assign(:route_elements, [
      stub_model(RouteElement),
      stub_model(RouteElement)
    ])
  end

  it "renders a list of route_elements" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
