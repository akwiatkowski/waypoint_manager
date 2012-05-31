describe Waypoint, :type => :model do
  context 'simple test' do
    it "should check basics" do
      m = FactoryGirl.create(:waypoint)
      m.valid?.should
    end
  end
end