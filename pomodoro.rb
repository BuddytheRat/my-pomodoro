class Pomodoro
  require './timer'
  require './getkey'
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
    @on_break = false

    run
  end

  def get_input(**args)
    args[:greater_than] ||= 0
    input = gets.chomp.to_i
    error = false
    if !input.integer?
        error = true
        puts 'Must be an integer.'
    elsif input <= args[:greater_than]
        error = true
        puts "Must be greater than #{args[:greater_than]}."
    end
    input = get_input if error
    input
  end

  def new_session(minutes, **args)
    args[:break] ||= false
    @timer = Timer.new(minutes)
    @timer.start
    @on_break = args[:break]
    @running = true
  end

  def sessions_string(sessions, completed)
    ("[x]" * completed) + ("[ ]" * (sessions - completed))
  end

  def display_session_status
    puts "Sessions:"
    puts sessions_string(@sessions, @sessions_completed)
    puts "Breaks:"
    puts sessions_string(@break_sessions, @breaks_completed)
  end

  def run
    loop do
      key = GetKey.getkey
      system('cls')
      display_session_status
      if @running
        if !@timer.running?
          @running = false
          @on_break ? @breaks_completed += 1 : @sessions_completed += 1
          next
        end
        puts
        puts @timer.time_to_s + ' | ' + @timer.percent
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
        @sessions_completed = [@sessions_completed - 1, 0].max if key == 's'.ord
        @sessions_completed = [@sessions_completed + 1, @sessions].min if key == 'S'.ord 
        @breaks_completed = [@breaks_completed - 1, 0].max if key == 'b'.ord
        @breaks_completed = [@breaks_completed + 1, @break_sessions].min if key == 'B'.ord
        new_session(30, :break => true) if key == '1'.ord
        new_session(30) if key == '2'.ord
        next if key
      end
      sleep 0.1
    end
  end
end

pom = Pomodoro.new()