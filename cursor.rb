require "io/console"
require "colorize"
require 'byebug'

KEYMAP = {
  " " => :space,
  "h" => :left,
  "j" => :down,
  "k" => :up,
  "l" => :right,
  "w" => :up,
  "a" => :left,
  "s" => :down,
  "d" => :right,
  "\t" => :tab,
  "\r" => :return,
  "\n" => :newline,
  "\e" => :escape,
  "\e[A" => :up,
  "\e[B" => :down,
  "\e[C" => :right,
  "\e[D" => :left,
  "\177" => :backspace,
  "\004" => :delete,
  "\u0003" => :ctrl_c,
}

MOVES = {
  left: [0, -1],
  right: [0, 1],
  up: [-1, 0],
  down: [1, 0]
}

class Cursor

  attr_reader :cursor_pos, :board, :color
  attr_accessor :selected_pos

  def initialize(board, color)
    @cursor_pos = (color == :w ? [7, 0] : [0, 0])
    @board = board
    @selected_pos = nil
    @color = color
  end

  def get_input
    key = KEYMAP[read_char]
    #debugger
    handle_key(key)
  end

  private

  def read_char
    STDIN.echo = false # stops the console from printing return values

    STDIN.raw! # in raw mode data is given as is to the program--the system
                 # doesn't preprocess special characters such as control-c

    input = STDIN.getc.chr # STDIN.getc reads a one-character string as a
                             # numeric keycode. chr returns a string of the
                             # character represented by the keycode.
                             # (e.g. 65.chr => "A")

    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil # read_nonblock(maxlen) reads
                                                   # at most maxlen bytes from a
                                                   # data stream; it's nonblocking,
                                                   # meaning the method executes
                                                   # asynchronously; it raises an
                                                   # error if no data is available,
                                                   # hence the need for rescue

      input << STDIN.read_nonblock(2) rescue nil
    end

    STDIN.echo = true # the console prints return values again
    STDIN.cooked! # the opposite of raw mode :)

    return input
  end

  #The customer is always an ninkompoop. And it's all about him.
  def handle_key(key)
    case key
    when :return, :space
      register_selection
    when :left, :right, :up, :down
      update_pos(MOVES[key])
      nil
    when :ctrl_c
       Process.exit(0)
    end
  end

  def register_selection
    if valid_piece? || self.selected_pos
      toggle_selected
      cursor_pos
    else
      nil
    end
  end

  def valid_piece?
    board[cursor_pos].color == color
  end

  #debuggle
  def toggle_selected
    if selected_pos == cursor_pos
      self.selected_pos = nil
    elsif selected_pos.nil?
      self.selected_pos = cursor_pos
    end
  end

  #We're doing this for you, customer. You know who you are.
  def update_pos(diff)
    new_pos_x = cursor_pos[0]+diff[0]
    new_pos_y = cursor_pos[1]+diff[1]
    @cursor_pos = [new_pos_x, new_pos_y] if board.in_range?([new_pos_x, new_pos_y])
  end
end
