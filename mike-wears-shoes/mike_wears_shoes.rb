
require 'mechanize_mike'
require 'time_handler'
# TODO remove pry after development
require 'pry'


Shoes.app(title: "Mike Wears Shoes", width: 454, height: 550) do
  
  extend TimeHandler
  
  mike = MechanizeMike.new

  background lime..mediumseagreen

  stack margin: 10 do
    # p home_page
    stack do
      @title = title "Let's Mechanize Mike!", left: 50
    end
    stack do
      @img = image "./assets/mike-mechanized-md.jpg", left: 100      
    end        
    
    @content1 = stack left: 100 do
      stack do
        para "Login"
        @user = edit_line 
        @user.text = mike.default_user
      end
      stack do
        para "Password"
        @password = edit_line 
        @password.text = mike.default_password
      end
      stack do
        para "Provider"
        @provider = edit_line 
        @provider.text = mike.default_provider
      end
      stack do
        @login_btn = button "Login", width: 100, height: 35
      end

    end
    
    @login_btn.click do
      # Log Mike in
      home_page = mike.login @user.text, @password.text, @provider.text      
      
      if home_page.form(action: "/auth/login") || home_page.title.include?("Login Failed")        
        # Bad login Try Again
        @content1.prepend { para "Bad Credentials Try again" }
      
      elsif home_page.form(name: "splash") || home_page.title.include?("Splash Message")
        # Splash page message needs to be displayed and submitted
        splash_msg_page = mike.get_splash_message home_page
        binding.pry

      else 
        # Success, time to get down
        @title  = "Mike Is Ready To Be Automated"
        @content1.remove
        @content2 = stack margin: 50 do
          flow do
            para "Start Year: "
            @start_year = list_box items: get_year_array, width: 70
            para " Month: "
            @start_month = list_box items: get_month_array, width: 50
            para " Day: "
            @start_day = list_box items: get_day_array, width: 50
          end
    
          flow do
            para " End Year: "
            @end_year = list_box items: get_year_array, width: 70        
            para " Month: "
            @end_month = list_box items: get_month_array, width: 50
            para " Day: "
            @end_day = list_box items: get_day_array, width: 50
          end  
          
          stack do
            button "Run Dates", left: 200 do 
              if !@start_year.text || !@start_month.text || !@start_day.text || !@end_year.text || !@end_month.text || !@end_day.text
                alert "Please select proper values"
              else
                alert @start_year.text + " - " + @end_year.text
              end
            end
          end  
          
        end
      end   
    end  
    
  end

  def alert_screen

  end
  
end


