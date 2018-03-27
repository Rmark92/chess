require_relative "piece"

class Pawn < Piece
  ATTACK_MOVES = { b: [[1, 1] ,[1, -1]],
                   w: [[-1, 1], [-1, -1]]
                 }.freeze

  FRIENDLY_MOVES = { b: [[1, 0]],
                     w: [[-1, 0]]
                   }
  JUMP_MOVES = { b: [[2, 0]],
                 w: [[-2, 0]]
               }

  def initialize(color, board, position)
    @starting_position = position
    super
  end

  def moves
    forward_moves + attack_moves
  end

  def symbol
    if color == :w
      "\u2659 "
    else
      "\u265F "
    end
  end

  def attack_moves

    moves = ATTACK_MOVES[color].map {|offset| [offset[0] + position[0], offset[1] + position[1]]}
    moves.select do |move|
      valid_attack_move?(move)
    end
  end

  def forward_moves
    offsets = FRIENDLY_MOVES[color]
    offsets += JUMP_MOVES[color] if position == @starting_position
    moves = offsets.map {|offset| [offset[0] + position[0], offset[1] + position[1]]}
    moves.select { |move| board.in_range?(move) && board[move].instance_of?(NullPiece) }
  end

  private

  def valid_attack_move?(move)
    #debugger
    board.in_range?(move) &&
    !board[move].instance_of?(NullPiece) &&
    board[move].color != color
  end
end
