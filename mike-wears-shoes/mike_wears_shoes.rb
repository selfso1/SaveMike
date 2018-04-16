
require 'mechanize_mike'
require 'time_handler'

mike = MechanizeMike.new

Shoes.app(title: "Mike Wears Shoes", width: 454, height: 650) do
  
  extend TimeHandler

  background lime..mediumseagreen

  boing = sound("./assets/61847__simon-rue__boink-v3.wav")
  img1 = "./assets/mike-mechanized-md.jpg"
  img2 = "./assets/mike-smiling-sm.png"

  stack margin: 10 do
    
    @title = stack do
      title "Let's Mechanize Mike!", left: 50
    end
    @image_stack = stack do
      image img1, left: 100      
    end        
    
    @content1 = stack left: 100, background: powderblue do
      stack do
        para "Login"
        @user = edit_line 
        @user.text = mike.default_user
      end
      stack do
        para "Password"
        @password = edit_line secret: true 
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
      
      boing.play
  
      # Log Mike in
      home_page = mike.login @user.text, @password.text, @provider.text      
      
      if mike.is_unsuccessful_login? home_page
        # Bad login Try Again
        times= 0
        @an1 = animate(30) do |i|
          times += i
          @image_stack.displace((Math.sin(i) * 6).to_i, 0)
          @an1.stop if times > 500
        end

        @content1.prepend do 
          para "Bad Credentials. Try again!", stroke: red, size: 18          
        end             
      else 
        # Success, time to get down
        @title.clear do 
          stack do 
            title "Ready To Automate", left: 55 
          end
        end
        @image_stack.clear do 
          @image_stack = stack do 
            image img2, left: 75, margin_bottom: 0
          end
        end

        @content1.remove
        
        # Splash page message needs to be displayed and submitted
        if mike.is_splash_page? home_page
          splash_msg_page = mike.get_splash_message home_page
          
          @contentpost = stack margin: 5 do 
            stack height: "100px", scroll: true, margin_right: 20 + gutter do 
              para splash_msg_page.at_css("#message").text, size: 12
            end
            stack do
              @post_button = button "Got it", width: 80, height: 35
            end  
          end 
          @post_button.click do
            @contentpost.remove
            home_page_new = mike.splash_page_submit home_page            
          end
        end 

        @content2 = stack margin_left: 50 do
          flow do
            para "Start Year: ", size: 12, stroke: darkred
            @start_year = list_box items: get_year_array, width: 70, choose: current_year.to_s           
            para " Month: ", size: 12, stroke: darkred
            @start_month = list_box items: get_month_array, width: 50, choose: current_month.to_s
            para " Day: ", size: 12, stroke: darkred
            @start_day = list_box items: get_day_array, width: 50, choose: current_day.to_s
          end
    
          flow do
            para " End Year: ", size: 12
            @end_year = list_box items: get_year_array, width: 70        
            para " Month: ", size: 12
            @end_month = list_box items: get_month_array, width: 50
            para " Day: ", size: 12
            @end_day = list_box items: get_day_array, width: 50
          end  
          
          flow do
            button "Run Dates", left: 200 do 
              if !@start_year.text || !@start_month.text || !@start_day.text
                alert "Please select all start values. \n End dates default to current date."
              else
                
                date_hash = {
                  start_year: @start_year.text.to_i,
                  start_month: @start_month.text.to_i,
                  start_day: @start_day.text.to_i,
                  end_year: @end_year.text ? @end_year.text.to_i : nil,
                  end_month: @end_month.text ? @end_month.text.to_i : nil,
                  end_day: @end_day.text ? @end_day.text.to_i : nil
                }
                submit_page = mike.iterate_dates date_hash                
                  
                @content2.prepend do
                  caption "Yep yep, \n #{mike.msg}. ", stroke: darkblue, margin_top: 0
                end
                @image_stack.clear do 
                  @image_stack = stack do 
                    image img1, left: 100, margin_bottom: 0
                  end
                end
              end
            end

            @oneday_button = button "Just Today", width: 100, height: 35
            
          end

          @oneday_button.click do  
            isp_page = mike.isp_date_page_submit       
            success_page = mike.isp_form_page_submit isp_page                

            @content2.prepend do
              caption "One Day Yep yep, \n #{mike.msg}. ", stroke: darkblue, margin_top: 0
            end  
            @image_stack.clear do 
              @image_stack = stack do 
                image img1, left: 100, margin_bottom: 0
              end
            end
          end
        end
      end   
    end  
    
  end
  
end


