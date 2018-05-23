require_relative "piece"

module Stepable
  def step_moves(offsets = nil)
    offsets ||= self.class::OFFSETS
    my_moves = []
    offsets.each do |offset|
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

  def initialize(color, board, position)
    @value = 30
    super
  end

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
  include Slideable

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

  CASTLE_OFFSETS = [[0, 1], [0, -1]]

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

  def initialize(color, board, position)
    @value = 1000
    super
  end

  def valid_moves
    valid_stepping_moves + valid_castle_moves
  end

  def valid_stepping_moves
    stepping_moves = step_moves(OFFSETS)
    stepping_moves.select {|move| !move_into_check?(move)}
  end

  def sliding_moves
    moves = []
    return moves if has_moved || board.in_check?(color)
    slide_moves(CASTLE_OFFSETS)
  end

  # def right_castle_move
  #
  # end
  #
  # def left_castle_move
  # end

  def valid_castle_moves
    sliding_moves_arr = sliding_moves
    castle_moves = []
    right = board[[position[0], 7]]
    right_slide = sliding_moves_arr.select { |_, col| (5..6).include?(col) }
    if right.instance_of?(Rook) && !right.has_moved && right_slide.size == 2 && right_slide.none? {|move| move_into_check?(move)}
      castle_moves += [[position[0], 6]]
    end

    left = board[[position[0], 0]]
    left_slide = sliding_moves_arr.select { |_, col| (2..3).include?(col) }
    if left.instance_of?(Rook) && !left.has_moved && left_slide.size == 2 && left_slide.none? {|move| move_into_check?(move)}
      castle_moves += [[position[0], 2]]
    end

    castle_moves
  end

  def symbol
    if color == :w
      "\u2654 "
    else
      "\u265A "
    end
  end
end
