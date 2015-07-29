class Pomodoro
  require './timer'
  require './getkey'
  require './timesheet'
	def initialize
    puts '# of hours to work:'
    work_hours = get_input
    puts '# of hours available:'
    available_hours = get_input(greater_than: work_hours)
    @sessions = (work_hours / 0.5).to_i
    @sessions_completed = 0
    @break_sessions = ((available_hours - work_hours) / 0.5).to_i
    @breaks_completed = 0
    @running = false
    @is_break = false

    run
  end

  def get_input(**args)
    args[:greater_than] ||= 1
    input = gets.chomp.to_i
    error = false
    if input < args[:greater_than]
        error = true
        puts "Must be a number equal to or greater than #{args[:greater_than]}."
    end
    input = get_input if error
    input
  end

  def new_session(minutes, **args)
    args[:is_break] ||= false
    args[:warning] ||= false
    @timer = Timer.new(minutes, warning: args[:warning])
    @timer.start
    @is_break = args[:is_break]
    @running = true
  end

  def sessions_string(sessions, completed)
    completed_string = ("[x]" * ([completed, sessions].min))
    uncompleted_string = ("[ ]" * ([sessions - completed, 0].max))
    excess_string = (" x " * ([completed - sessions, 0].max))
    completed_string + uncompleted_string + excess_string
  end

  def display_session_status
    puts "Sessions:"
    puts sessions_string(@sessions, @sessions_completed)
    puts "Breaks:" if @break_sessions > 0
    puts sessions_string(@break_sessions, @breaks_completed) if @break_sessions > 0
  end

  def run
    loop do
      key = GetKey.getkey
      system('cls')
      display_session_status
      if @running
        if !@timer.running?
          @running = false
          @is_break ? @breaks_completed += 1 : @sessions_completed += 1
          next
        end
        puts
        puts @timer.time_to_s
        #### TIMER CONTROLS ####
        @timer.time_up if key == 's'.ord && @timer.running?
        @timer.pause if key == 'p'.ord && @timer.running?
        @timer.start if key == 'r'.ord && @timer.paused?
        next if key
      else
        puts "Press '1' for break. Press '2' for pomodoro."
        puts "Press 's' to remove completed session. Press 'b' to remove completed break."
        puts "Hold shift to add, instead."
        #### SESSION CONTROLS ####
        new_session(30, is_break: true) if key == '1'.ord # New Break
        new_session(30, warning: true) if key == '2'.ord  # New Session
      end
      @sessions_completed = [@sessions_completed - 1, 0].max if key == 's'.ord
      @sessions_completed = @sessions_completed + 1 if key == 'S'.ord 
      @breaks_completed = [@breaks_completed - 1, 0].max if key == 'b'.ord
      @breaks_completed = @breaks_completed + 1 if key == 'B'.ord
      next if key
      sleep 0.2
    end
  end
end

pom = Pomodoro.new()