require 'mechanize'
# additionally we can use logger to log mechanize actions
require 'logger'
require 'date'

@website = 'https://secure.therapservices.net'

#date_arg = ARGV[0]
agent = Mechanize.new
agent.log = Logger.new "mechanize.log"

login_page  = agent.get "#@website/auth/login"

login_form = login_page.form(id: 'authForm')

cookie_field = login_form.field_with(name: "cookieEnabled")
email_field = login_form.field_with(name: "loginName")
password_field = login_form.field_with(name: "password")
provider_field = login_form.field_with(name: "providerCode")

email_field.value = 'rfinnigan'
password_field.value = 'Siftit123'
provider_field.value = 'CCI-CO'
cookie_field.value = true

home_page = login_form.submit

#(Date.new(2017, 9, 13)..Date.new(2017, 9, 26)).each do |date|
	date = Time.now 
	date_arg = date.strftime("%m/%d/%Y")
	#next if ["05/18/2016", "05/16/2016", "05/01/2016", "03/13/2016", "02/03/2016", "02/02/2016", "01/08/2016", "12/07/2015", "11/28/2015", "11/29/2015", "11/30/2015"].include? date_arg
	#isp_choose  = agent.get "#@website/ma/isp/individualListData?pgmId=98291&backLink=%2fnewfpage%2fswitchFirstPage&backType=1"
	#isp_choose  = agent.get "#@website/ma/isp/dateSelect?formId=ISP-CCICO-EAL4QAEVV7677&backLink=%2Fnewfpage%2FswitchFirstPage&backType=2"
	isp_choose  = agent.get "#@website/ma/isp/dateSelect?formId=ISP-CCICO-FAQ4V2RVXPKT3&backLink=ispDataList"
	date_form = isp_choose.form
	date_field = date_form.field_with(name: 'ispData.dataCollectionDate')
	date_field.value = date_arg #'01/08/2016'
	date_button = date_form.button_with(value: 'Submit')
	isp_page = date_form.submit date_button
	isp_form = isp_page.form

	location_field = isp_form.field_with(name: 'ispData.location')
	taskcomment1_field = isp_form.field_with(name: 'ispData.taskScores[0].comments')
	taskcomment2_field = isp_form.field_with(name: 'ispData.taskScores[1].comments')
	submit_button = isp_form.button_with(name: 'saveButton')

	comment_field = isp_form.field_with(name: 'ispData.comments')

	location_field.value = "House"
	
	routine_file = File.expand_path("../mikes-routine.txt", __FILE__)
	file = File.open(routine_file, "rb")
	contents = file.read

	act1_file = File.expand_path("../Activities1.txt", __FILE__)
	file2 = File.open(act1_file, "rb")
	contents2 = file2.read

	act2_file = File.expand_path("../Activities2.txt", __FILE__)
	file3 = File.open(act2_file, "rb")
	contents3 = file3.read

	options = contents.split("//")
	length = options.count
	comment = options[rand(0..(length-1))]
        comment_field.value = comment #"Morning routine. Mike hung out around the house and ate lunch at home. watched some tv, and then out to dinner with HHP. Back home for a cleanup."

	options2 = contents2.split("//")
	length2 = options2.count
	comment2 = options2[rand(0..(length2-1))]
	taskcomment1_field.value = comment2

	options3 = contents3.split("//")
	length3 = options3.count
	comment3 = options3[rand(0..(length3-1))]
	taskcomment2_field.value = comment3
	submitpage = isp_form.submit submit_button
#p submitpage
        if submitpage.uri.to_s.include?("https://secure.therapservices.net/ma/common/done")
	    p "#{date_arg} processed"
	else
	    p "#{date_arg} SOMETHING WENT WRONG!"
	end
        #sleep 5
#end
