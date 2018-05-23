require_relative "display"
require_relative "cursor"
require_relative "move_search"
require 'byebug'

class Player
  attr_reader :board, :color, :name

  def initialize(name, board, color)
    @board = board
    @color = color
    @name = name
  end
end

class AIPlayer < Player
  def initialize(board, color)
    super('BeepBoop', board, color)

  end

  def get_move
    @move_search = MoveSearch.new(@board, self.color)
    @move_search.find_best
    # debugger
    return @move_search.best
  end
  #
  # def get_move
  #   pieces = board.pieces(self.color)
  #   pieces.each do |piece|
  #     debugger
  #     p piece.class
  #     p piece.valid_moves
  #   end
  # end
  #
  # def alpha_beta(alpha, beta, depth = 2)
  #
  # end


end

class HumanPlayer < Player
  attr_reader :board, :color, :name

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
