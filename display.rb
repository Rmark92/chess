require "colorize"
require_relative "board"
require_relative "cursor"

class Display
  attr_reader :board, :cursor
  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], board)
  end

  # def display
  #   @board.each {|row| p row}
  # end

  # it's all about the customer!
  def render
    system ('clear')
  #  cursor.handle_key("s") #down
    x, y = cursor.cursor_pos

    @board.grid.each.with_index do |row, i|
      row.each.with_index do |piece, j|
        if [i, j] == [x, y]
          print piece.to_s.colorize(:red)
        else
          print piece
        end
      end
      puts
    end
  end
end
