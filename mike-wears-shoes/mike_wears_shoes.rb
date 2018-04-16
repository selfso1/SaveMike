
require 'mechanize_mike'

mike = MechanizeMike.new
# home_page = mike.login

Shoes.app(title: "Mike Wears Shoes", width: 450) do
  background lime..mediumseagreen

  stack margin: 10 do
    # p home_page
    stack do
      title "Let's Mechanize Mike!", left: 50
    end
    stack do
      @img = image "./assets/mike-mechanized.jpg", left: 80
    end

    now = Time.now
    current_year = now.year
    current_month = now.month
    current_day = now.day
    month_array = [
      current_month - 12, current_month - 11, current_month - 10, current_month - 9, current_month - 8, current_month - 7, 
      current_month - 6 , current_month - 5, current_month - 4, current_month - 3, current_month - 2, current_month - 1, current_month
    ]
    
    day_array = [
      current_day - 31, current_day - 30, current_day - 29, current_day - 28, current_day - 27, current_day - 26, current_day - 25, 
      current_day - 24, current_day - 23, current_day - 22, current_day - 21, current_day - 20, current_day - 19, current_day - 18, 
      current_day - 17, current_day - 16, current_day - 15, current_day - 14, current_day - 13, current_day - 12, current_day - 11,
      current_day - 10, current_day - 9, current_day - 8, current_day - 7, current_day - 6, current_day - 5, current_day - 4, 
      current_day - 3, current_day - 2, current_day - 1, current_day
    ]
    stack margin: 50 do
      flow do
        para "Start Year: "
        @start_year = list_box items: [current_year - 1, current_year], width: 70
        @start_year.choose(current_year)
        para " Month: "
        @start_month = list_box items: month_array, width: 50
        para " Day: "
        @start_day = list_box items: day_array, width: 50
      end

      flow do
        para "End Year: "
        @end_year = list_box items: [current_year - 1, current_year], width: 70
        
        para " Month: "
        @end_month = list_box items: month_array, width: 50
        para " Day: "
        @end_day = list_box items: day_array, width: 50
      end  
      
      stack margin: 10 do
        button "Run Dates" do 

          alert @start_year.text + " - " + @end_year.text
        end
      end    
    end    
    
  end
end


