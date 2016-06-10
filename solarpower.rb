  # takes in total wats and a hash of pumps
  # total watts being used cant surpass 80% of total wats
  # example ..total wats = 10
  # hash of pumps = {1: [true, 3], 2: [false, 0], 3: [true, 4]}
  # turns pumps off if exceed 80%
  # should return the same value because the total wats used does not exceed 7


class SolarManagement
  
  def initialize(readpanel, read_outlet)     #gets the wats and outlets
    @watts = readpanel                      
    @outlets = read_outlet
    @rest_list = {}
  end

  def rest_list          #method there for test purposes
    @rest_list
  end
  
  def outlet_off(id)         
    @outlets[id][0] = false
    @outlets[id][1] = 0
    @rest_list[id] = Time.now
  end	
  
  def outlet_on(id)             
  	@outlets[id][0] = true
  	@outlets[id][1] = (@watts * 0.6)/@outlets.length    # 60% of total watts/ number of outlets
  end

  def rest
    if !@rest_list.empty?                 
      @rest_list.each do |id,time|
        if (Time.now - time) >= (60 * 5)   #check to see if five minutes passed after it was turned off
          outlet_on id 
          @rest_list.delete(id) 
        end
      end  
    end
  end

  def regulate(pumps)             #recursive method to get it under 80%
      pumps = pumps.sort.reverse  
      id = pumps.shift[1]
      outlet_off id
      total_wats_now = 0
      pumps.each do |pump|
        total_wats_now += pump[0]
      end
     if total_wats_now >= (@watts * 0.8)
        regulate pumps
     end
     pumps
  end


  def main(readpanel=@watts, read_outlet=@outlets)   #optional parameters in case watts or outlets changes, easier to test
    @outlets = read_outlet || @outlets
    @watts = readpanel || @watts 
    total_wats_used = 0
    on_pumps = []
    @outlets.each do |id, status|           #loop check for outlets that are on and stick them in an array
      if status[0] == true
        total_wats_used += status[1]
        on_pumps << [status[1], id]
      elsif !@rest_list.include?(id)       #if pump starts of as off then send it to the rest_list if it dont exist there
        @rest_list[id] = Time.now
      end
    end
    rest                                
    if total_wats_used >= (@watts * 0.8)   
      regulate on_pumps
    end
    @outlets          # returns status of the outlets
  end
end




