require_relative "display"
require_relative "cursor"
require 'byebug'

class Player
end
class HumanPlayer < Player
  attr_reader :board, :color, :name

  def initialize(name, board, color)
    @board = board
    @color = color
    @name = name
  end

  def get_move
    my_cursor = Cursor.new(board, color)
    my_display = Display.new(board, my_cursor)
    move_pos = nil
    loop do
      my_display.render
      puts move_pos
      move_pos = my_cursor.get_input
      break if two_positions_selected?(move_pos, my_cursor.selected_pos)
    end
    [my_cursor.selected_pos, move_pos]
  end

  private

  def two_positions_selected?(move_pos, selected_pos)
    move_pos && selected_pos && (move_pos != selected_pos)
  end
end
