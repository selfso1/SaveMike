
require 'mechanize_mike'
require 'time_handler'
# TODO remove pry after development
require 'pry'


Shoes.app(title: "Mike Wears Shoes", width: 454, height: 650) do
  
  extend TimeHandler
  
  mike = MechanizeMike.new

  background lime..mediumseagreen

  stack margin: 10 do
    
    @title = stack do
      title "Let's Mechanize Mike!", left: 50
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
      
      if mike.is_unsuccessful_login? home_page
        # Bad login Try Again
        @content1.prepend { para "Bad Credentials Try again" }             

      else 
        # Success, time to get down
        @title.clear do 
          stack do 
            title "Ready To Automate", left: 30 
          end
        end

        @content1.remove
        
        # Splash page message needs to be displayed and submitted
        if mike.is_splash_page? home_page
          splash_msg_page = mike.get_splash_message home_page
          
          @contentpost = stack margin: 5 do 
            stack height: "100px", scroll: true do 
              para splash_msg_page.at_css("#message").text
            end
            @post_button = button "Got it", width: 80, height: 35
          end 
          @post_button.click do
            @contentpost.remove
            home_page_new = mike.splash_page_submit home_page            
          end
        end 

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
                alert "Please select values for all the form items. "
              else
                date_hash = {
                  start_year: @start_year.text.to_i,
                  start_month: @start_month.text.to_i,
                  start_day: @start_day.text.to_i,
                  end_year: @end_year.text.to_i,
                  end_month: @end_month.text.to_i,
                  end_day: @end_day.text.to_i
                }
                submit_page = mike.iterate_dates date_hash
                
                @content2.prepend { "Yep yep, \n #{mike.msg}" }
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


