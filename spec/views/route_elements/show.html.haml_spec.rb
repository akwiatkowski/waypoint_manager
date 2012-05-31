require 'spec_helper'

describe "route_elements/show" do
  before(:each) do
    @route_element = assign(:route_element, stub_model(RouteElement))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
