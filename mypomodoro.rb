class MyPomodoro
  require './mypomodoro/timer'
  require './mypomodoro/breaktimer'
  require './mypomodoro/timesheet'
  require './mypomodoro/getkey'

	def initialize
    @in_session = false
    load_timesheet
    run
  end

  def load_timesheet
    TimeSheet.load
    @timesheet = TimeSheet.today ? TimeSheet.today : TimeSheet.new
  end

  def new_session(minutes)
    @timesheet.add_break_time(@timer.run_time)
    @timer = Timer.new(minutes)
    @timer.start
    @in_session = true
  end

  def end_session
    @timesheet.add_session
    @timer.time_up
    @timer = nil
    @in_session = false
  end

  def display
    ordinal = ['st', 'nd', 'rd', 'th'].each_with_index.find do |ord, i| 
      i+1 == Time.now.mday % 10 || i+1 > 3
    end
    puts Time.now.strftime('%A, %-d' + ordinal[0] + ' of %B')
    puts
    puts "Sessions: #{@timesheet.sessions}, Total: #{TimeSheet.sessions}" # Sessions
    puts "Break Time Today: #{@timesheet.break_time}" # Break Times
    puts
    puts @timer.time_to_s if @timer # Timer String
  end

  def run
    loop do
      key = GetKey.getkey
      system('cls')
      display
      TimeSheet.save
      if @in_session
        end_session if key == 'S'.ord || !@timer.running?
        @timer.pause if key == 'p'.ord
        @timer.start if key == 'r'.ord && @timer.paused?
      else
        if !@timer
          @timer = BreakTimer.new
          @timer.start
        end
        new_session(30) if key == '1'.ord
        @timesheet.remove_session if key == '-'.ord
        @timesheet.add_session if key == '+'.ord
      end
      next if key
      sleep 0.2
    end
  end
end

pom = MyPomodoro.new