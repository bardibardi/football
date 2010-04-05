module Cook

  def self.rating(r)
    r = 1000.0*r + 10000.5
    r.to_s[1...2] + '.' + r.to_s[2...5]
  end

  def self.month(month)
    return 'January' if '01' == month
    return 'February' if '02' == month
    return 'March' if '03' == month
    return 'April' if '04' == month
    return 'May' if '05' == month
    return 'June' if '06' == month
    return 'July' if '07' == month
    return 'August' if '08' == month
    return 'September' if '09' == month
    return 'October' if '10' == month
    return 'November' if '11' == month
    return 'December' if '12' == month
  end

  def self.date_time(date)
    d = date.to_s
    year = d[0...4]
    month = d[4...6]
    day = d[6...8]
    day[0] = ' ' if 48 == day[0]
    if 8 == d.length then
      return day + '&nbsp;' + month(month)
    end
    hour = d[8...10]
    minute = d[10...12]
    day + '&nbsp;' + month(month) +
      ' at ' + hour + ':' + minute
  end

  def self.probability(p)
    p = 10000.0*p + 10000.5
    cp = p.to_s[1...3] + '.' + p.to_s[3...5] + '%'
    cp[0] = ' ' if 48 == cp[0]
    cp
  end

end
