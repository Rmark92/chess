require_relative "piece"

class Knight < Piece
  def symbol
    if color == :w
      "\u2658 "
    else
      "\u265E "
    end
  end
end

class King < Piece
  def symbol
    if color == :w
      "\u2654 "
    else
      "\u265A "
    end
  end
end
