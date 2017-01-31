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

email_field.value = ''
password_field.value = ''
provider_field.value = 'CCI-CO'
cookie_field.value = true

home_page = login_form.submit

#(Date.new(2015, 12, 17)..Date.new(2016, 07, 16)).each do |date|
	date = Time.now
	date_arg = date.strftime("%m/%d/%Y")
	#next if ["05/18/2016", "05/16/2016", "05/01/2016", "03/13/2016", "02/03/2016", "02/02/2016", "01/08/2016", "12/07/2015", "11/28/2015", "11/29/2015", "11/30/2015"].include? date_arg
	#isp_choose  = agent.get "#@website/ma/isp/individualListData?pgmId=98291&backLink=%2fnewfpage%2fswitchFirstPage&backType=1"
	isp_choose  = agent.get "#@website/ma/isp/dateSelect?formId=ISP-CCICO-EAL4QAEVV7677&backLink=%2Fnewfpage%2FswitchFirstPage&backType=2"
	date_form = isp_choose.form
	date_field = date_form.field_with(name: 'ispData.dataCollectionDate')
	date_field.value = date_arg #'01/08/2016'
	isp_page = date_form.submit

	isp_form = isp_page.form
	#begin_field = isp_form.field_with(name: 'frm.beginTimeHour')
	#end_field = isp_form.field_with(name: 'frm.endTimeHour')
	#begin_min_field = isp_form.field_with(name: 'frm.beginTimeMinute')
	#end_min_field = isp_form.field_with(name: 'frm.endTimeMinute')

	#begin_am_field = isp_form.radiobuttons_with(name: 'frm.beginTimeAmPm')[0].check
	#end_am_field = isp_form.radiobuttons_with(name: 'frm.endTimeAmPm')[1].check
	location_field = isp_form.field_with(name: 'ispData.location')
	#task1_field = isp_form.field_with(name: 'frm.taskScores[0].score').options[(rand(5..6))].select
	#task2_field = isp_form.field_with(name: 'frm.taskScores[1].score').options[(rand(5..6))].select
	#task3_field = isp_form.field_with(name: 'frm.taskScores[2].score').options[(rand(5..6))].select
	#billable_field = isp_form.radiobuttons_with(name: 'frm.billable')[0].check
	taskcomment1_field = isp_form.field_with(name: 'ispData.taskScores[0].comments')
	taskcomment2_field = isp_form.field_with(name: 'ispData.taskScores[1].comments')
	#taskcomment3_field = isp_form.field_with(name: 'ispData.comments')
	press_field = isp_form.field_with(name: 'saveButton')

	comment_field = isp_form.field_with(name: 'ispData.comments')

	#begin_field.options[8].select
	#end_field.options[9].select
	#begin_min_field.options[1].select
	#end_min_field.options[1].select
	location_field.value = "House"
	#taskcomment1_field.value="Mike vacuumed his room."
	#taskcomment2_field.value="Mike took out trash."
	#taskcomment3_field.value="na"
	#press_field.value = "Save"

	file = File.open("mikes-routine.txt")
	contents = file.read

	file2 = File.open("Activities1.txt")
	contents2 = file2.read

	file3 = File.open("Activities2")
	contents3 = file3.read

	options = contents.split("//")
	length = options.count
	comment = options[rand(0..(length-1))]
  comment_field = comment #"Morning routine. Mike hung out around the house and ate lunch at home. watched some tv, and then out to dinner with HHP. Back home for a cleanup."

	options2 = contents2.split("//")
	length2 = options2.count
	comment2 = options2[rand(0..(length2-1))]
	taskcomment1_field = comment2

	options3 = contents3.split("//")
	length3 = options.count
	comment3 = options3[rand(0..(length3-1))]
	taskcomment2_field = comment3

	submitpage = isp_form.submit
	p "#{date_arg} processed"
        #sleep 10
#end
