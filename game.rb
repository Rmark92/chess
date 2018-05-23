require_relative 'board'
require_relative 'player'

class Game
  attr_accessor :current_player
  attr_reader :board, :player1, :player2

  def initialize
    @board = Board.new
    @player1 = HumanPlayer.new('Ryan', board, :w)
    @player2 = AIPlayer.new(board, :b)
    @current_player = player1
  end

  def run
    game_result = nil
    until game_result
      take_turn
      game_result = board.game_result(current_player.color)
    end
    game_over_message(game_result)

  end

  def game_over_message(result)
    display = Display.new(board)
    display.render
    case result
    when :stalemate
      puts "It's a tie...pathetic!"
    when :checkmate
      puts "#{other_player.name} wins!  #{current_player.name} loses!"
    end
  end

  def other_player
    current_player == player1 ? player2 : player1
  end

  def take_turn
    begin
      old_pos, new_pos = current_player.get_move
      board.move_piece(old_pos, new_pos)
    rescue InvalidMoveError => e
      puts e.message
      retry
    end
    switch_turn
  end

  def switch_turn
    self.current_player = other_player
  end
end

game = Game.new
game.run
