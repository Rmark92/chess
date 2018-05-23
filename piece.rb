class Piece
  attr_reader :board, :color, :position, :value
  attr_accessor :has_moved

  def initialize(color, board, position)
    @board = board
    @color = color
    @position = position
    @has_moved = false
  end

  def to_s
    symbol
  end

  def abbrev_display
    puts self.class
    puts self.position
  end

  def empty?
  end

  def valid_moves
    my_moves = moves
    my_moves.select {|move| !move_into_check?(move)}
  end

  def is_valid_move?(move)
    board.in_range?(move) && !move_into_check(move)
  end

  def position=(new_pos)
    @position = new_pos
    # debugger if self.instance_of?(King)
    # @has_moved = true
  end

  def moves
    if self.respond_to?('slide_moves')
      slide_moves
    elsif self.respond_to?('step_moves')
      step_moves
    end
  end

  # def symbol
  #   @symbol
  # end

  private

  def move_into_check?(en_pos)
    # debugger if [[1, 4], [1, 2], [2, 1], [3, 0]].include?(en_pos)
    into_check = false
    board.test_move(position, en_pos) do |tmp_brd|
      into_check = tmp_brd.in_check?(self.color)
    end
    into_check
  end
  #
  # def move_into_check?(en_pos)
  #   old_position = position
  #   temp_move(en_pos)
  #   return_val = board.in_check?(self.color)
  #   undo_move(old_position)
  #   return_val
  # end
  #
  # def temp_move(new_pos)
  #   board[position] = NullPiece.instance
  #   board[new_pos] = self
  # end
  #
  # def undo_move(old_pos)
  #   board[position] = NullPiece.insance
  #   board[old_pos] = self
  # end

end





# String unicodeMessage =
#                       "\u2654 " + // white king
#                       "\u2655 " + // white queen
#                       "\u2656 " + // white rook
#                       "\u2657 " + // white bishop
#                       "\u2658 " + // white knight
#                       "\u2659 " + // white pawn
#                       "\n" +
#                       "\u265A " + // black king
#                       "\u265B " + // black queen
#                       "\u265C " + // black rook
#                       "\u265D " + // black bishop
#                       "\u265E " + // black knight
#                       "\u265F " + // black pawn
#                       "\n" ;
