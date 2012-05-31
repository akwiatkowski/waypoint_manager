require 'spec_helper'

describe Route do
  context 'creating' do
    it "should create from factory" do
      m = FactoryGirl.create(:route)
      m.should be_valid
    end

    it "should create from factory with 2 route elements" do
      m = FactoryGirl.create(:route)

      m.route_elements << FactoryGirl.create(:route_element)
      m.route_elements << FactoryGirl.create(:route_element)
      m.should be_valid

      m.save!

      m.reload
      m.route_elements.size.should == 2
    end
  end
end
