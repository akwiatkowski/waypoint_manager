# encoding: utf-8

require 'spec_helper'

describe Waypoint, :type => :model do
  context 'creating' do
    it "should create from factory" do
      m = FactoryGirl.create(:waypoint)
      m.should be_valid
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

      m.lat.should be_within(0.0001).of(50.79167)
      m.lon.should be_within(0.0001).of(15.83333)

    end

    it "should create from Hash" do
      h = {
        dms_coords: '50°47′30.01″N 15°50′00″E',
        elevation: 500
      }

      m = Waypoint.new(h)
      m.should be_valid

      m.should be_valid
      m.save!

      m.lat.should be_within(0.0001).of(50.79167)
      m.lon.should be_within(0.0001).of(15.83333)
    end

    it "should create from Hash without DMS" do
      h = {
        lat: 50.79167,
        lon: 15.83333,
        dms_coords: '',
        elevation: 500
      }

      m = Waypoint.new(h)
      m.should be_valid

      m.should be_valid
      m.save!

      m.lat.should be_within(0.0001).of(50.79167)
      m.lon.should be_within(0.0001).of(15.83333)
    end

  end
end