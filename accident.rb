require 'logger'
require 'time'
require 'date'

def ping_accident(log, n_time, m_time, t_time, number)
  filename = DateTime.now.strftime('%Y%m%d%H%M%S')
  logger = Logger.new("./#{filename}.log")
  logger.datetime_format = ''

  logA = []
  logB = []
  logC = []
  logD = []
  
  log.each do |l|
    if l[3] == "A"
      logA << l
    elsif l[3] == "B"
      logB << l
    elsif l[3] == "C"
      logC << l
    else l[3] == "D"
      logD << l
    end
  end

  avg = 0
  [logA,logB,logC,logD].each do |abcd|
    abcd.last(m_time).each do |x|
      if x[2] == "-"
        avg += 30000
      else
        avg += x[2].to_i
      end
    end
    if avg/m_time >= t_time
      dt = Time.parse(abcd[-1][0]) + abcd[-1][2].to_i;
      overload = "過負荷状態: #{abcd[-1][1]}, #{abcd[-(m_time)][0]} - #{dt.strftime("%Y%m%d%H%M%S")}"
      logger.error(overload)
    end
  end

  (number.length - n_time).times do |i|
    if (number[n_time + i - 1] - number[i]) == n_time - 1
      dt = Time.parse(log[number[n_time + i - 1]][0]) + log[number[n_time + i - 1]][2].to_i;
      accident = "故障: #{log[number[i]][1]}, #{log[number[i]][0]} - #{dt.strftime("%Y%m%d%H%M%S")}"
      logger.error(accident)
    end
  end

end

log = []
number = []
last_line = 0

File.open('ping.log'){|f|
  f.each_line{|line|
    a = line.chomp.split(",")
    if a[1] == "10.20.30.1/16"
      a << "A"
    elsif a[1] == "10.20.30.2/16"
      a << "B"
    elsif a[1] == "192.168.1.1/24"
      a << "C"
    else a[1] == "192.168.1.2/24"
      a << "D"
    end
    log.push a

    if a[2] == "-"
      number.push f.lineno
    end
  }
}

puts 'サーバ故障のタイムアウト回数を指定してください'
n_time = gets.to_i
puts '直近何回以上の平均値から検出するか指定してください'
m_time = gets.to_i
puts '平均応答値が何ミリ秒以上の場合にサーバ過負荷状態とみなすか指定してください'
t_time = gets.to_i
ping_accident(log, n_time, m_time, t_time, number)
