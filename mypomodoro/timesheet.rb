class TimeSheet
  require 'yaml'
  @@timesheets = Hash.new
  attr_reader :sessions, :break_time
  def initialize
    @initialized = Time.now
    #One TimeSheet Object per day.
    @@timesheets[@initialized.strftime('%m-%d-%y')] = self
    @sessions = 0 # Number of pomodoro sessions completed
    @break_time = 0 # Number of seconds of break time
  end

  def TimeSheet.load
    data = File.open('timesheet.yaml', 'r') { |f| f.read }
    @@timesheets = YAML.load(data)
  end

  def TimeSheet.save
    save = YAML.dump(@@timesheets)
    File.open('timesheet.yaml', 'w') { |f| f.write(save) }
  end

  def TimeSheet.sessions
    sessions = 0
    @@timesheets.values.each { |v| sessions += v.sessions }
    sessions
  end

  def break_time
    time_to_s(@break_time)
  end

  def time_to_s(seconds_float)
    seconds = (seconds_float % 60).to_i.to_s.rjust(2, '0')
    minutes = ((seconds_float / 60) % 60).to_i.to_s.rjust(2, '0')
    hours   = ((seconds_float / 3600) % 60).to_i.to_s.rjust(2, '0')
    "#{hours}:#{minutes}:#{seconds}"
  end 

  def TimeSheet.today
    @@timesheets[Time.now.strftime('%m-%d-%y')]
  end

  def add_session
    @sessions += 1
  end

  def remove_session
    @sessions = [@sessions - 1, 0].max
  end

  def add_break_time(time) # time is a float, acquired by subtracting two Time objects.
    @break_time += time
  end
end
