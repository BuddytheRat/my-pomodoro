class TimeSheet
  @@timesheets = Hash.new
  attr_reader :sessions, :break_time
  def initialize
    @initialized = Time.now
    #One TimeSheet Object per day.
    @@timesheets[@initialized.strftime('%m-%d-%y')] ||= self
    @sessions = 0 # Number of pomodoro sessions completed
    @break_time = 0 # Number of seconds of break time
  end

  def TimeSheet.sessions
    sessions = 0
    @@timesheets.values.each { |v| sessions += v.sessions }
    sessions
  end

  def TimeSheet.break_time
    break_time = 0
    @@timesheets.values.each { |v| break_time += v.break_time }
    break_time
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