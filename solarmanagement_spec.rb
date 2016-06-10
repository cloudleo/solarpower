require 'timecop'
require 'minitest/autorun'
require './solarpower'

    	
describe SolarManagement do
	before do 
  Timecop.scale(600)  # this manipulates seconds into 5 minutes
	end 

	describe "#turns_off_the_highest" do
	  it "returns the right answer" do
			wats = 12
		  pumps = {1 => [true, 3], 2 => [true, 4], 3 => [true, 5], 4 => [true, 4]}
		  solarpower = SolarManagement.new(wats,pumps)
		  answer = {1=>[true, 3], 2=>[true, 4], 3=>[false, 0], 4=>[false, 0]}
		  solarpower.main.must_equal answer
	  end
	end

	describe "#only_runs_code_if_capacity_is_over_80%" do
		it "doesn't change value" do
			wats = 16
			pumps =  {1 => [true, 2], 2 => [true, 2], 3 => [true, 2], 4 => [true, 2]}
			solarpower = SolarManagement.new(wats,pumps)
			solarpower.main.must_equal pumps
	  end
	end
  describe "#turns_back_on_after_5minutes" do
  	it "pumps return true after 5 minutes of being off"  do
  	 wats = 12
  	 pumps = {1 => [false, 0], 2 => [false, 0], 3 => [true, 2], 4 => [true, 2]}
  	 solarpower = SolarManagement.new(wats,pumps)
     solarpower.main
     sleep(1)     #so five minutes can passed
     solarpower.main
     solarpower.rest_list.empty?.must_equal true
  	end
  end


end

