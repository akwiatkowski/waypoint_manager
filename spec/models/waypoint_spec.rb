# encoding: utf-8

describe Waypoint, :type => :model do
  context 'creating' do
    it "should create from factory" do
      m = FactoryGirl.create(:waypoint)
      m.valid?.should
    end

    it "should create from factory and use other coords format" do
      m = FactoryGirl.create(:waypoint)
      m.should be_valid

      m.dms_coords = '50°47′30.01″N 15°50′00″E'
      # maybe later
      #m.lat = '50°47′30.01″N'
      #m.lon = '15°50′00″E'

      m.should be_valid
      m.save!

      m.lat 

    end
  end
end