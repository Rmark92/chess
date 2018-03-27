require_relative "piece"
require 'byebug'

module Slideable
  def slide_moves(offsets = nil)
    offsets ||= self.class::OFFSETS
    #debugger
    result = []
    offsets.each do |offset|
      multiplier = 0
      loop do
        multiplier += 1
        new_position = calculate_position(offset, multiplier)
        if !board.in_range?(new_position)
          break
        elsif board[new_position].instance_of?(NullPiece)
          result << new_position
        elsif board[new_position].color == self.color
          break
        else
          result << new_position
          break
        end
      end
    end
    result
  end

  def calculate_position(offset, multiplier)
    [offset[0] * multiplier + position[0],
     offset[1] * multiplier + position[1]]
  end

  HORIZONTAL = [[0,1], [0, -1]]
  VERTICAL = [[1, 0], [-1, 0]]
  DIAGONAL =  [[1,1], [-1, -1], [1, -1], [-1, 1]]
end

class Rook < Piece
  include Slideable

  OFFSETS = Slideable::HORIZONTAL + Slideable::VERTICAL

  def symbol
    if color == :w
      "\u2656 "
    else
      "\u265C "
    end
  end
end

class Bishop < Piece
  include Slideable

  OFFSETS = Slideable::DIAGONAL

  def symbol
    if color == :w
      "\u2657 "
    else
      "\u265D "
    end
  end
end

class Queen < Piece
  include Slideable

  OFFSETS = Slideable::HORIZONTAL + Slideable::VERTICAL + Slideable::DIAGONAL
  def symbol
    if color == :w
      "\u2655 "
    else
      "\u265B "
    end
  end
end
