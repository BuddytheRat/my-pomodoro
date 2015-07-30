module GetKey
 
  # Check if Win32API is accessible or not
  USE_STTY = begin
      require 'Win32API'
      KBHIT = Win32API.new('crtdll', '_kbhit', [ ], 'I')
      GETCH = Win32API.new('crtdll', '_getch', [ ], 'L')
      false
    rescue LoadError
      # Use Unix way
      true
    end
 
  # Return the ASCII code last key pressed, or nil if none
  #
  # Return::
  # * _Integer_: ASCII code of the last key pressed, or nil if none
  def self.getkey
    if USE_STTY
      char = nil
      begin
        system('stty raw -echo') # => Raw mode, no echo
        char = (STDIN.read_nonblock(1).ord rescue nil)
      ensure
        system('stty -raw echo') # => Reset terminal mode
      end
      return char
    else
      return KBHIT.Call.zero? ? nil : GETCH.Call
    end
  end
 
end