require 'spec_helper'

describe "route_elements/new" do
  before(:each) do
    assign(:route_element, stub_model(RouteElement).as_new_record)
  end

  it "renders new route_element form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => route_elements_path, :method => "post" do
    end
  end
end
