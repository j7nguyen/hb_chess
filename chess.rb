=begin
This program takes in a state of a chess board, represented by an array of arrays.
Each row has 'EE' for empty, or two-character string with the first character representing
the color of the piece and the second character representing the type, i.e. 'WN' for white knight.
'P' = Pawn, 'R' = Rook, 'N' = Knight, 'B' = Bishop, 'K' = King, 'Q' = Queen
=end
class Chess
  INITIAL_BOARD =
  [
    ['BR','BN','BB','BK','BQ','BB','BN','BR'],
    ['BP','BP','BP','BP','BP','BP','BP','BP'],
    ['EE','EE','EE','EE','EE','EE','EE','EE'],
    ['EE','EE','EE','EE','EE','EE','EE','EE'],
    ['EE','EE','EE','EE','EE','EE','EE','EE'],
    ['EE','EE','EE','EE','EE','EE','EE','EE'],
    ['WP','WP','WP','WP','WP','WP','WP','WP'],
    ['WR','WN','WB','WK','WQ','WB','WN','WR']
  ]

  PIECES = {
    'P' => 'Pawn',
    'R' => 'Rook',
    'N' => 'Knight',
    'B' => 'Bishop',
    'K' => 'King',
    'Q' => 'Queen'
  }
  attr_accessor :board

  def initialize(board=INITIAL_BOARD)
    @board = board
  end

  def formatted_moves(color)
    pieces = find_pieces(color)
    move_strings = []
    moves = check_player_moves(pieces, color)
    moves.each do |move|
      piece_name = PIECES[move[0][0]]
      start_row, start_col = move[0][1,2]
      dest_row, dest_col = move[1]
      move_str = "#{piece_name} at <#{start_row + 1}:#{start_col + 1}> can move " +
        "to <#{dest_row + 1}:#{dest_col + 1}>"
      move_strings << move_str
    end
    num_unique_pieces = moves.map{|move| move[0]}.uniq.count
    move_strings << "#{moves.length} legal moves (#{num_unique_pieces} unique" +
    " pieces) for #{color_string(color)} player"
    move_strings
  end

  def color_string(color)
    color == 'W' ? 'white' : 'black'
  end

  def find_pieces(color)
    pieces = []
    @board.each_with_index do |row, rownum|
      row.each_with_index do |space, colnum|
        if space != 'EE' && space[0] == color
          pieces << [space[1], rownum, colnum]
        end
      end
    end
    pieces
  end

  def check_player_moves(pieces, color)
    moves = []
    pieces.each do |piece|
      possible_moves = check_piece_moves(piece, color).sort
      possible_moves.each do |move|
        moves << [piece, move]
      end
    end
    moves
  end

  def check_piece_moves(piece, color)
    case piece[0]
    when "P"
      find_pawn_moves(piece, color)
    when "R"
      find_rook_moves(piece, color)
    when "N"
      find_knight_moves(piece, color)
    when "B"
      find_bishop_moves(piece, color)
    when "K"
      find_king_moves(piece, color)
    when "Q"
      find_queen_moves(piece, color)
    else
      puts "Error, invalid piece"
    end
  end

  def find_pawn_moves(piece, color)
    moves = []
    row, col = piece[1,2]
    difference = (color == 'W' ? -1 : 1)
    start_row = (color == 'W' ? 6 : 1)
    one_forward, two_forward = row + difference, row + 2 * difference
    if legal_space?(one_forward, col, color)
      moves << [one_forward, col]
      if row == start_row && legal_space?(two_forward, col, color)
        moves << [two_forward, col]
      end
    end
    moves
  end

  def find_rook_moves(piece, color)
    find_horiz_vert_line_moves(piece, color)
  end

  def find_knight_moves(piece, color)
    directions = [[1,2], [1,-2], [2,1], [2,-1], [-1,2], [-1,-2], [-2,1], [-2,-1]]
    find_one_move(directions, piece, color)
  end

  def find_bishop_moves(piece, color)
    find_diagonal_line_moves(piece, color)
  end

  def find_king_moves(piece, color)
    directions = [[-1,-1], [-1,0], [-1,1], [0,-1],[0,1],[1,-1],[1,0],[1,1]]
    find_one_move(directions, piece, color)
  end

  def find_queen_moves(piece, color)
    straight_moves = find_horiz_vert_line_moves(piece, color)
    diagonal_moves = find_diagonal_line_moves(piece, color)
    straight_moves + diagonal_moves
  end

  def find_horiz_vert_line_moves(piece, color)
    directions = [[-1,0], [0,-1], [0,1], [1,0]]
    find_line_moves(directions, piece, color)
  end

  def find_diagonal_line_moves(piece, color)
    directions = [[-1,-1], [-1,1], [1,-1], [1,1]]
    find_line_moves(directions, piece, color)
  end

  def find_one_move(directions, piece, color)
    moves = []
    row, col = piece[1,2]
    directions.each do |direction|
      check_row, check_col = row + direction[0], col + direction[1]
      moves << [check_row, check_col] if legal_space?(check_row, check_col, color)
    end
    moves
  end

  def find_line_moves(directions, piece, color)
    moves = []
    row, col = piece[1,2]
    directions.each do |direction|
      check_row, check_col = row + direction[0], col + direction[1]
      exhausted = false
      until exhausted
        if legal_space?(check_row, check_col, color)
          moves << [check_row, check_col]
          exhausted = true unless @board[check_row][check_col] == 'EE'
          check_row += direction[0]
          check_col += direction[1]
        else
          exhausted = true
        end
      end
    end
    moves
  end

  def legal_space?(row, col, color)
    return false if row < 0 || col < 0 || row > 7 || col > 7
    space = @board[row][col]
    space == 'EE' || space[0] != color
  end
end
