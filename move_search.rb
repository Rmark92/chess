class MoveSearch
  attr_reader :best

  def initialize(board, color)
    @board = board
    @color = color
    @max_depth = 3
    @best = nil
  end

  def other_color(color)
    color == :w ? :b : :w
  end

  def find_best
    start = Time.now
    alpha_beta(@color, -50_000, 50_000, @max_depth)
    p Time.now - start
  end

  def alpha_beta(color, alpha, beta, depth)
    if depth == 0
      state_scores = @board.calculate_scores
      return state_scores[color] ** 2 - state_scores[other_color(color)] ** 2
    end

    game_result = @board.game_result(color)
    if game_result
      return { stalemate: 0, checkmate: -11_000 }[game_result]
    end

    min = nil

    @board.pieces(color).each do |piece|
      debugger if piece.position.nil?
      original_piece_pos = piece.position.dup
      # debugger if depth == @max_depth
      piece.valid_moves.each do |new_pos|
        no_valid_move = false
        @board.test_move(original_piece_pos, new_pos) do
          score = -alpha_beta(other_color(color), -beta, -alpha, depth - 1)
          if score >= beta
            min = beta
          elsif score > alpha
            if depth == @max_depth
              @best = [original_piece_pos, new_pos]
              p @best
              p score
            end
            alpha = score
          end
        end
        return min if min
      end
      # debugger if depth == @max_depth
    end
    alpha
  end

  #   next_moves = board.moves_for(color)
  #
  #   if next_moves.empty?
  #     return board.in_check?(color) ? -1_000_000 : 0
  #   end
  #
  #   next_moves.each do |move|
  #     new_board = board.dup
  #     new_board.execute_move!(move[:piece].dup, move[:pos], move[:new_pos])
  #     score = -alpha_beta(new_board, Board.other_color(color), -beta, -alpha, depth - 1)
  #     if score >= beta
  #       return beta
  #     elsif score > alpha
  #       @best = move if depth == @max_depth
  #       alpha = score
  #     end
  #   end
  #   alpha
  # end
end
