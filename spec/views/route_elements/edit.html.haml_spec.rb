require 'spec_helper'

describe "route_elements/edit" do
  before(:each) do
    @route_element = assign(:route_element, stub_model(RouteElement))
  end

  it "renders the edit route_element form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => route_elements_path(@route_element), :method => "post" do
    end
  end
end
