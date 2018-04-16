require 'mechanize'
# additionally we can use logger to log mechanize actions
require 'logger'
require 'date'
require 'pry'

class MechanizeMike 

  def initialize 
    @website = 'https://secure.therapservices.net'
    @agent = Mechanize.new
    @agent.log = Logger.new "mechanize.log"
  end

  # login first ask questions later
  # TODO validate if there is a splash page and submit answer
  # @return home_page
  def login email_val = nil, password_val = nil , provider = nil
    email_val = email_val ? email_val : 'rfinnigan'
    password = password_val ? password_val : 'Siftit123'
    provider = provider ? provider : 'CCI-CO'

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
    # binding.pry
    home_page
  end
  
  # 1st page of isp requires user to select date to submit
  # @return main isp_page
  def isp_date_page_submit date = nil
    date ||= Time.now
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
  def isp_form_page_submit isp_page
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
  
    if submitpage.uri.to_s.include?("https://secure.therapservices.net/ma/common/done")
      p "#{date_arg} processed"
    else
      p "#{date_arg} SOMETHING WENT WRONG!"
    end

    submitpage
  end

  def get_file_val file_type
    file_url = "../"

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

  def iterate_dates date_vals = {}
    start_year = date_vals.fetch(:start_year) {}
    start_month = date_vals.fetch(:start_month) {}
    start_day = date_vals.fetch(:start_day) {}
    end_year = date_vals.fetch(:end_year) {}
    end_month = date_vals.fetch(:end_month) {}
    end_day = date_vals.fetch(:end_day) {}

    Date.new(start_year, start_month, start_day)..Date.new(end_year, end_month, end_month).each do |date|
      isp_date_page_submit date
    end
  end

end