class MyPomodoro
  require './mypomodoro/timer'
  require './mypomodoro/breaktimer'
  require './mypomodoro/timesheet'
  require './mypomodoro/session'
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
    end_break
    @session_timer = Timer.new(minutes)
    @session = Session.new
    @session_timer.start
    @in_session = true
  end

  def resume_session
    end_break
    @session_timer.start
  end

  def end_session
    @session.end
    @timesheet.add_session(@session)
    @session_timer.time_up
    @session_timer = nil
    @in_session = false
  end

  def end_break
    @timesheet.add_break_time(@break_timer.run_time)
    @break_timer = nil
  end

  def display
    ordinal = ['st', 'nd', 'rd', 'th'].each_with_index.find do |ord, i| 
      i+1 == Time.now.mday % 10 || i+1 > 3
    end
    puts Time.now.strftime('%A, %-d' + ordinal[0] + ' of %B')
    puts
    puts "Sessions: #{@timesheet.sessions.size}, Total: #{TimeSheet.sessions.size}"
    puts "Break Time Today: #{@timesheet.break_time}"
    puts
    puts "Current Session: " + @session_timer.time_to_s if @session_timer
    puts "Taking Break: " + @break_timer.time_to_s if @break_timer
  end

  def run
    loop do
      key = GetKey.getkey
      system('cls')
      display
      TimeSheet.save
      if @in_session
        end_session if key == 'S'.ord || !@session_timer.running?
        @session_timer.pause if key == 'p'.ord
        resume_session if key == 'r'.ord && @session_timer.paused?
      else
        new_session(25) if key == '1'.ord
        @timesheet.remove_session if key == '-'.ord
        @timesheet.add_session if key == '+'.ord
      end
      if (!@session_timer || @session_timer.paused?) && !@break_timer
        @break_timer = BreakTimer.new
        @break_timer.start
      end
      break if key == 'Q'.ord
      next if key
      sleep 0.5
    end
  end
end

pom = MyPomodoro.new