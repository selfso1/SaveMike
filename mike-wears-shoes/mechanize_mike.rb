require 'mechanize'
# additionally we can use logger to log mechanize actions
require 'logger'
require 'date'
require 'pry'

class MechanizeMike 

  attr_accessor :msg
  
  def initialize 
    @website = 'https://secure.therapservices.net'
    @agent = Mechanize.new
    # @agent.log = Logger.new "mechanize.log"
    @msg = ""
  end

  def default_user
    'rfinnigan'
  end

  def default_password
    'Siftit123'
  end
  
  def default_provider
    'CCI-CO'
  end

  # login first ask questions later
  # TODO validate if there is a splash page and submit answer
  # @return home_page
  def login email_val = nil, password_val = nil , provider = nil
    email_val = email_val ? email_val : default_user
    password = password_val ? password_val : default_password
    provider = provider ? provider : default_provider

    login_page  = @agent.get "#@website/auth/login"

    login_form = login_page.form(id: 'authForm')

    cookie_field = login_form.field_with(name: "cookieEnabled")
    email_field = login_form.field_with(name: "loginName")
    password_field = login_form.field_with(name: "password")
    provider_field = login_form.field_with(name: "providerCode")

    email_field.value = email_val
    password_field.value = password_val
    provider_field.value = provider
    cookie_field.value = true
    
    home_page = login_form.submit
    home_page
  end
  
  # 1st page of isp requires user to select date to submit
  # @return main isp_page
  def isp_date_page_submit date = nil
    date = date ? date : Time.now
    date_arg = date.strftime("%m/%d/%Y")
    #next if ["05/18/2016", "05/16/2016", "05/01/2016", "03/13/2016", "02/03/2016", "02/02/2016", "01/08/2016", "12/07/2015", "11/28/2015", "11/29/2015", "11/30/2015"].include? date_arg
    #isp_choose  = agent.get "#@website/ma/isp/individualListData?pgmId=98291&backLink=%2fnewfpage%2fswitchFirstPage&backType=1"
    #isp_choose  = agent.get "#@website/ma/isp/dateSelect?formId=ISP-CCICO-EAL4QAEVV7677&backLink=%2Fnewfpage%2FswitchFirstPage&backType=2"
    isp_choose  = @agent.get "#@website/ma/isp/dateSelect?formId=ISP-CCICO-FAQ4V2RVXPKT3&backLink=ispDataList"
    
    date_form = isp_choose.form
    
    date_field = date_form.field_with(name: 'ispData.dataCollectionDate')
    date_field.value = date_arg #'01/08/2016'
    date_button = date_form.button_with(value: 'Submit')
    
    isp_page = date_form.submit date_button
    isp_page
    
  end

  # 2nd page of isp form
  # @return success page
  def isp_form_page_submit isp_page, date
    isp_form = isp_page.form

    location_field = isp_form.field_with(name: 'ispData.location')
    taskcomment1_field = isp_form.field_with(name: 'ispData.taskScores[0].comments')
    taskcomment2_field = isp_form.field_with(name: 'ispData.taskScores[1].comments')
    submit_button = isp_form.button_with(name: '_action_save')

    comment_field = isp_form.field_with(name: 'ispData.comments')

    location_field.value = "House"

    comment_field.value = get_file_val("routine")
    taskcomment1_field.value = get_file_val("activity1")
    taskcomment2_field.value = get_file_val("activity2")

    submitpage = isp_form.submit submit_button
  
    date = date ? date : Time.now
    date_arg = date.strftime("%m/%d/%Y")
    if submitpage.uri.to_s.include?("https://secure.therapservices.net/ma/common/done")
      @msg << "#{date_arg} processed. "
    else
      @msg << "#{date_arg} SOMETHING WENT WRONG! "
    end

    submitpage

  end

  def splash_page_submit home_page
    form = home_page.form(name: "splash")
    marked_read_field = form.checkbox_with(name: 'markedRead')
    marked_read_field.value = "checked"
    form.field_with(name: "actionButton").value = "firstPage"
    dashboard_page = form.submit
    dashboard_page

  end

  def get_splash_message home_page
    form = home_page.form(name: "splash")
    current_message_id = form.field_with(name: 'currentMessageId').value
    splash_msg_page = @agent.get "#@website/ma/splash/messageView?messageId=#{current_message_id}"
    splash_msg_page

  end

  def iterate_dates date_vals = {}
    start_year = date_vals.fetch(:start_year) { Time.now.year }
    start_month = date_vals.fetch(:start_month) { Time.now.month }
    start_day = date_vals.fetch(:start_day) { Time.now.day }
    end_year = date_vals.fetch(:end_year) { Time.now.year }
    end_month = date_vals.fetch(:end_month) { Time.now.month }
    end_day = date_vals.fetch(:end_day) { Time.now.day }

    (Date.new(start_year.to_i, start_month, start_day)..Date.new(end_year, end_month, end_day)).each do |date|
      isp_page = isp_date_page_submit date      
      success_page = isp_form_page_submit isp_page, date
    end

  end

  def get_file_val file_type
    file_url = "../../"

    case file_type
    when "activity1"
      file_name = "Activities1.txt"
    when "activity2"
      file_name = "Activities2.txt"
    when "routine"
      file_name = "mikes-routine.txt"
    end

    file_path = File.expand_path(file_url + file_name, __FILE__)
    file = File.open(file_path, "rb")
    contents = file.read
    options = contents.split("//")
    length = options.count
    file_val = options[rand(0..(length-1))]
    file_val

  end

  def is_unsuccessful_login? home_page
    home_page.form(action: "/auth/login") || home_page.title.include?("Login Failed")
  end
  
  def is_splash_page? home_page
    home_page.form(name: "splash") || home_page.title.include?("Splash Message")
  end

end