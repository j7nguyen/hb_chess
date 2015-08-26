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

  attr_accessor :board

  def initialize(board=INITIAL_BOARD)
    @board = board
  end

  def all_moves(board, color)
    pieces = find_pieces(board, color)
    check_moves(pieces, board)
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
    end
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
  end

  def find_knight_moves(piece, color)
  end

  def find_bishop_moves(piece, color)
  end

  def find_king_moves(piece, color)
  end

  def find_queen_moves(piece, color)
  end

  def find_straight_line_moves(rownum, colnum, board, color)
  end

  def find_diagonal_line_moves(rownum, colnum, board, color)
  end

  def legal_space?(row, col, color)
    space = @board[row][col]
    space == 'EE' || space[0] != color
  end
end
