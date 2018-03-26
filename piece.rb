class Piece
  attr_reader :board, :color, :position

  def initialize(color, board, position)
    @board = board
    @color = color
    @position = position
  end

  def to_s
    symbol
  end

  def empty?
  end

  def valid_moves
  end

  def pos=(val)
  end

  # def symbol
  #   @symbol
  # end

  private

  def move_into_check?(en_pos)
  end
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
