require 'Singleton'
require_relative "piece"


class NullPiece < Piece
  include Singleton

  def initialize
    @color = :magenta
    @symbol = :freedom #I answer to no king
    @value = 0
  end

  def moves
    []
  end

  def symbol
    # "\u200A_"
    "_ "
  end

end
