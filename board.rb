require_relative "null_piece"
require_relative "slideable_pieces"
require_relative "stepable_pieces"
require_relative "pawn"
require_relative "cursor"


class Board
  attr_reader :grid
  def self.create_new_board
    Array.new(8) {Array.new(8) {NullPiece.instance}}
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



  def initialize(board = nil)
    @grid = board
    if @grid == nil
      @grid = Board.create_new_board
      set_pieces
    end
  end

  def move_piece(start_pos, end_pos)
    unless valid_pos?(start_pos) && valid_pos?(end_pos)
      raise "Invalid Position. Try again. You can do better. Idiot."
    end

    piece_at_start_pos = @grid[start_pos[0]][start_pos[1]]
  end

end
