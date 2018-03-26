require_relative "piece"

class Pawn < Piece
  def symbol
    if color == :w
      "\u2659 "
    else
      "\u265F "
    end
  end
end
