require_relative "piece"

class Rook < Piece
  def symbol
    if color == :w
      "\u2656 "
    else
      "\u265C "
    end
  end
end

class Bishop < Piece
  def symbol
    if color == :w
      "\u2657 "
    else
      "\u265D "
    end
  end
end

class Queen < Piece
  def symbol
    if color == :w
      "\u2655 "
    else
      "\u265B "
    end
  end
end
