# This program takes in a state of a chess board, represented by an array of
# arrays. Each row has 'EE' for empty, or two-character string with the first
# character representing the color of the piece and the second character
# representing the type, i.e. 'WN' for white knight.

# Methods assume correctly formatted inputs, including the board and color.
# Calculations are performed using 0-7 as indices, but output indices are 1-8.

class Chess
  # default state for the board of a chess object
  INITIAL_STATE =
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

  # Create a Chess object with a board formatted like INITIAL_STATE above.
  # If a board is not passed in, INITIAL_STATE will be used.
  #
  def initialize(board=INITIAL_STATE)
    @board = board
  end

  # Once a board is created, formatted possible moves for each color can be
  # generated. Use print_moves for an easy-to-read format or formatted_moves for
  # the strings in an array.
  #
  def print_moves(color)
    color = color[0].upcase
    puts formatted_moves(color)
  end

  def formatted_moves(color)
    pieces = find_pieces(color)
    move_strings = []
    moves = check_player_moves(pieces, color)
    moves.each do |move|
      piece_name = PIECES[move[0][0]]
      start_row, start_col = move[0][1,2]
      dest_row, dest_col = move[1]
      move_str = "#{piece_name} at <#{start_row + 1}:#{start_col + 1}> can " +
        "move to <#{dest_row + 1}:#{dest_col + 1}>"
      move_strings << move_str
    end
    num_unique_pieces = moves.map{|move| move[0]}.uniq.count
    move_strings << "#{moves.length} legal moves (#{num_unique_pieces} " +
    "unique pieces) for #{color_string(color)} player"
    move_strings
  end

  def color_string(color)
    color == 'W' ? 'white' : 'black'
  end

  # Finds all of a player's pieces on the board.
  #
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

  # For each piece, checks all moves and creates an array of possible moves.
  #
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

  # Depending on the piece in question, a different method is used.
  #
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

  # Accounts for all the unique ways in which pawns can move and capture.
  #
  def find_pawn_moves(piece, color)
    moves = []
    row, col = piece[1,2]
    direction = (color == 'W' ? -1 : 1)
    start_row = (color == 'W' ? 6 : 1)
    one_forward, two_forward = row + direction, row + 2 * direction
    if @board[one_forward][col] == 'EE' && legal_space?(one_forward, col, color)
      moves << [one_forward, col]
      if row == start_row && @board[two_forward][col] == 'EE'
        moves << [two_forward, col]
      end
    end
    opposite = (color == 'W' ? 'B' : 'W')
    [[one_forward, col - 1], [one_forward, col + 1]].each do |capture_try|
      cap_row, cap_col = capture_try
      if legal_space?(cap_row, cap_col, color)
        moves << capture_try if @board[cap_row][cap_col][0] == opposite
      end
    end
    moves
  end

  def find_rook_moves(piece, color)
    find_horiz_vert_line_moves(piece, color)
  end

  def find_knight_moves(piece, color)
    directions = [[1,2],[1,-2],[2,1],[2,-1],[-1,2],[-1,-2],[-2,1],[-2,-1]]
    find_one_move(directions, piece, color)
  end

  def find_bishop_moves(piece, color)
    find_diagonal_line_moves(piece, color)
  end

  def find_king_moves(piece, color)
    directions = [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]]
    find_one_move(directions, piece, color)
  end

  def find_queen_moves(piece, color)
    straight_moves = find_horiz_vert_line_moves(piece, color)
    diagonal_moves = find_diagonal_line_moves(piece, color)
    straight_moves + diagonal_moves
  end

  # Used by rooks and queens.
  #
  def find_horiz_vert_line_moves(piece, color)
    directions = [[-1,0], [0,-1], [0,1], [1,0]]
    find_line_moves(directions, piece, color)
  end

  # Used by bishops and queens
  #
  def find_diagonal_line_moves(piece, color)
    directions = [[-1,-1], [-1,1], [1,-1], [1,1]]
    find_line_moves(directions, piece, color)
  end

  # Used by knights and kings.
  #
  def find_one_move(directions, piece, color)
    moves = []
    row, col = piece[1,2]
    directions.each do |direction|
      check_row, check_col = row + direction[0], col + direction[1]
      moves << [check_row, check_col] if legal_space?(check_row, check_col, color)
    end
    moves
  end

  # Used by rooks, bishops, and queens. Finds possible moves along a line until
  # it reaches an edge of the board, the player's own piece, or the player has
  # captured a piece.
  #
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

  # Checks if a specified space can be moved to by a player's piece. It must be
  # on the board and not have one of the player's pieces.
  #
  def legal_space?(row, col, color)
    return false if row < 0 || col < 0 || row > 7 || col > 7
    space = @board[row][col]
    space == 'EE' || space[0] != color
  end
end


# Example to demonstrate pawn capture ability and other piece movements.
#
test_board = [
  ['BR','BN','BB','BK','EE','BB','BN','BR'],
  ['BP','BP','BP','BP','EE','BP','BP','BP'],
  ['EE','EE','EE','EE','EE','EE','EE','EE'],
  ['EE','EE','EE','EE','BP','EE','BQ','EE'],
  ['EE','EE','EE','WP','WP','EE','WQ','EE'],
  ['EE','EE','EE','EE','EE','EE','EE','EE'],
  ['WP','WP','WP','EE','EE','WP','WP','WP'],
  ['WR','WN','WB','WK','EE','WB','WN','WR']
]

game = Chess.new
game.print_moves('w')
