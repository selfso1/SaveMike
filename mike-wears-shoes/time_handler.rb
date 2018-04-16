module TimeHandler

  def current_time 
    @now ||= Time.now  
  end
  
  def current_year
    now = current_time
    @current_year ||= now.year
  end
  
  def current_month
    now = current_time
    @current_month ||= now.month
  end

  def current_day
    now = current_time
    @current_day ||= now.day
  end

  def offset_month offset 
    diff = current_month - offset
  
    if diff < 1 
      12 + diff
    else 
      diff
    end
  end
  
  def offset_day offset 
    diff = current_day - offset
  
    if diff < 1 
      31 + diff
    else 
      diff
    end
  end
  
  def get_year_array
    @year_array ||= [current_year - 1, current_year]
  end
  
  
  def get_month_array
    current_time
    @month_array ||= [
      offset_month(12), offset_month(11), offset_month(10), offset_month(9), offset_month(8), offset_month(7), 
      offset_month(6) , offset_month(5), offset_month(4), offset_month(3), offset_month(2), offset_month(1), offset_month(0)
    ].uniq!.sort!
  end
  
  def get_day_array
    current_time
    @day_array ||= [
      offset_day(31), offset_day(30), offset_day(29), offset_day(28), offset_day(27), offset_day(26), offset_day(25), 
      offset_day(24), offset_day(23), offset_day(22), offset_day(21), offset_day(20), offset_day(19), offset_day(18), 
      offset_day(17), offset_day(16), offset_day(15), offset_day(14), offset_day(13), offset_day(12), offset_day(11),
      offset_day(10), offset_day(9), offset_day(8), offset_day(7), offset_day(6), offset_day(5), offset_day(4), 
      offset_day(3), offset_day(2), offset_day(1), offset_day(0)
    ].uniq!.sort!
  end
end