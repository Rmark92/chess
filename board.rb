require_relative "null_piece"
require_relative "slideable_pieces"
require_relative "stepable_pieces"
require_relative "pawn"


class InvalidMoveError < StandardError; end

class Board
  include Enumerable
  attr_reader :grid
  def self.create_new_board
    Array.new(8) {Array.new(8) {NullPiece.instance}}
  end

  def initialize(grid = nil)
    @grid = grid
    if @grid == nil
      @grid = Board.create_new_board
      set_pieces
    end
  end


  def each
    grid.flatten.each { |piece| yield(piece) }
  end

  def [](position)
    row, col = position
    grid[row][col]
  end

  def []=(position, value)
    row, col = position
    grid[row][col] = value
  end

  def in_range?(position)
    position.all? { |coord| coord >= 0 && coord < 8 }
  end

  def in_check?(color)

    opponents_pieces = select {|piece| piece.color != color && !piece.instance_of?(NullPiece)}

    king_position = detect { |piece| piece.instance_of?(King) && piece.color == color }
    king_position = king_position.position

    opponents_pieces.each do |opponent_piece|
      return true if opponent_piece.moves.include?(king_position)
    end
    false
  end

  def game_result(color)
    if game_over?(color)
      in_check?(color) ? :checkmate : :stalemate
    else
      nil
    end
  end

  def game_over?(color)
    color_pieces = select {|piece| piece.color == color}
    color_pieces.each do |color_piece|
      return false unless color_piece.valid_moves.empty?
    end

    true
  end

  def castle_rook(old_pos, new_pos)
    if (new_pos[1] > old_pos[1])
      rook_pos = [new_pos[0], 7]
      self[rook_pos].has_moved = true
      move(rook_pos, [new_pos[0], 5])
    else
      rook_pos = [new_pos[0], 0]
      self[rook_pos].has_moved = true
      move(rook_pos, [new_pos[0], 3])
    end
  end

  def uncastle_rook(old_pos, new_pos)
    if (new_pos[1] > old_pos[1])
      rook_pos = [new_pos[0], 5]
      self[rook_pos].has_moved = false
      move(rook_pos, [new_pos[0], 7])
    else
      rook_pos = [new_pos[0], 3]
      self[rook_pos].has_moved = false
      move(rook_pos, [new_pos[0], 0])
    end
  end

  def move_piece(old_pos, new_pos)
    piece = self[old_pos]
    if piece.valid_moves.include?(new_pos)
      castle_rook(old_pos, new_pos) if piece.instance_of?(King) &&
                                       (old_pos[1] - new_pos[1]).abs > 1
      move(old_pos, new_pos)
      piece.has_moved = true
    else
      raise InvalidMoveError, "Invalid position choice"
    end
  end

  # def unmove_piece(old_pos, new_pos)
  #   piece = self[new_pos]
  #   uncastle_rook(old_pos, new_pos) if piece.instance_of?(King) &&
  #                                      (old_pos[1] - new_pos[1]).abs > 1
  #   move(new_pos, old_pos)
  #   piece.has_move = false
  # end


  def move(old_pos, new_pos)
    captured = self[new_pos]
    self[new_pos] = self[old_pos]
    self[old_pos] = NullPiece.instance
    self[new_pos].position = new_pos
    captured
  end

  def test_move(old_pos, new_pos, &prc)
    piece = self[old_pos]
    original_piece_moved = piece.has_moved
    captured = move(old_pos, new_pos)
    # captured.position = nil unless captured.instance_of?(NullPiece)
    castle_rook(old_pos, new_pos) if piece.instance_of?(King) &&
                                     (old_pos[1] - new_pos[1]).abs > 1
    return_val = prc.call(self)
    uncastle_rook(old_pos, new_pos) if piece.instance_of?(King) &&
                                       (old_pos[1] - new_pos[1]).abs > 1
    move(new_pos, old_pos)
    piece.has_moved = original_piece_moved
    # debugger unless captured.instance_of?(NullPiece)
    # captured.position = new_pos unless captured.instance_of?(NullPiece)
    self[new_pos] = captured
  end

  def pieces(color)
    piece_arr = []
    each { |piece| piece_arr <<  piece if piece.color == color }
    piece_arr
  end

  def calculate_scores
    scores = { w: 0, b: 0}
    each do |square|
      next unless scores[square.color]
      scores[square.color] += square.value
    end
    scores
  end

  # def self.set_pieces
  #   @board.each_with_index do |row, i|
  #     row.each_with_index do |square, j|
  #       if i == 1
  #         #setup white pawns
  #       elsif i == 6
  #         #set up black pawns
  #       elsif i == 0
  #         #set up white strong pieces
  #       elsif i == 7
  #         #set up black strong pieces
  #       end
  #     end
  #   end
  # end

  def set_pieces
    set_up_pawns(:w)
    set_up_power_pieces(:w)
    set_up_pawns(:b)
    set_up_power_pieces(:b)
  end

  def set_up_pawns(color)
    if color == :w
      row = 6
    else
      row = 1
    end
    @grid[row].map!.with_index {|square, index| Pawn.new(color, self, [row, index])}

  end

  def abbrev_display
    self.grid.map do |row|
      row.map { |sq| sq.class }
    end
  end

  def set_up_power_pieces(color)
    if color == :w
      row = 7
    else
      row = 0
    end

    power_piece_arr = [
      Rook.new(color, self, [row, 0]),
      Knight.new(color, self, [row, 1]),
      Bishop.new(color, self, [row, 2]),
      Queen.new(color, self, [row, 3]),
      King.new(color, self, [row, 4]),
      Bishop.new(color, self, [row, 5]),
      Knight.new(color, self, [row, 6]),
      Rook.new(color, self, [row, 7]),
    ]

    @grid[row] = power_piece_arr

  end

end


# ♜ _ ♝ ♚ _ ♝ ♞ ♜
# ♟ ♟ ♟ _ _ ♟ ♟ ♟
# _ _ ♞ _ _ _ _ _
# _ _ _ _ ♙ _ _ _
# _ _ _ _ ♟ _ _ _
# _ _ ♘ _ _ _ ♙ _
# ♙ ♙ ♙ _ _ ♙ _ ♙
# ♖ _ ♗ _ ♔ ♗ ♘ ♖
#
# CHARS_PIECES = { '♙' => Proc.new { |pos| Pawn.new(pos, color) }
# def recreate_board
#
# end

# board = Board.new
# board.grid[1].map! {|square| NullPiece.instance}
# board.move([7, 3], [1,4])
# display = Display.new(board)
# display.render
# positions =  (0..7).map do |col|
#   board[[0, col]].valid_moves
# end
# p positions
# board[[0,4]].valid_moves
