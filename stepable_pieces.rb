require_relative "piece"

module Stepable
  def moves
    my_moves = []
    self.class::OFFSETS.each do |offset|
      my_moves << [offset[0] + position[0], offset[1] + position[1]]
    end
    my_moves.select {|move| board.in_range?(move) && board[move].color != color}
  end
end




class Knight < Piece
  include Stepable
  OFFSETS = [
    [1, 2],
    [1, -2],
    [2, 1],
    [2, -1],
    [-2, 1],
    [-2, -1],
    [-1, 2],
    [-1, -2]
  ]
  def symbol
    if color == :w
      "\u2658 "
    else
      "\u265E "
    end
  end
end

class King < Piece

  include Stepable
  OFFSETS = [
    [0, 1],
    [1, 0],
    [0, -1],
    [-1, 0],
    [1, 1],
    [1, -1],
    [-1, 1],
    [-1, -1]
  ]

  # def castle_moves
  #   moves = []
  #   return moves if has_moved
  #   row = position[0]
  #
  #   right = board[row, 7]
  #   if path_clear(7) && right.instance_of?(Rook) && !right.has_moved
  #     moves += [[row, 6]]
  #   end
  #
  #   left = board[row, 0]
  #   if path_clear(0) && left.instance_of?(Rook) && !left.has_moved
  #     moves += [[row, 2]]
  #   end
  #
  #   moves
  # end
  #
  # def moves
  #   #debugger
  #   result = []
  #   self.class::OFFSETS.each do |offset|
  #     multiplier = 0
  #     loop do
  #       multiplier += 1
  #       new_position = calculate_position(offset, multiplier)
  #       if !board.in_range?(new_position)
  #         break
  #       elsif board[new_position].instance_of?(NullPiece)
  #         result << new_position
  #       elsif board[new_position].color == self.color
  #         break
  #       else
  #         result << new_position
  #         break
  #       end
  #     end
  #   end
  #   result
  # end

  def symbol
    if color == :w
      "\u2654 "
    else
      "\u265A "
    end
  end
end
