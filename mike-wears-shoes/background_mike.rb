
require './mechanize_mike'
require './time_handler'

if ARGV.length > 0 
  date = DateTime.parse(ARGV[0]).to_date
else 
  date = nil
end
 
mike = MechanizeMike.new

mike.run_isp date
