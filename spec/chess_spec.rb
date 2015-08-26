require './chess.rb'

RSpec.describe Chess, '#legal_space' do
  context "For an empty space" do
    it "allows either color to move there" do
      chess = Chess.new
      expect(chess.legal_space?(5,0, 'W')).to eq true
      expect(chess.legal_space?(5,0, 'B')).to eq true
    end
  end
end

RSpec.describe Chess, '#find_pieces' do
  context "For either player" do
    it "finds all that player's pieces" do
      chess = Chess.new
      expect(chess.find_pieces('W')[0]).to eq ['P', 6, 0]
      expect(chess.find_pieces('B')[7]).to eq ['R', 0, 7]
    end
  end
end

RSpec.describe Chess, '#find_pawn_moves' do
  context "For white pawn" do
    it "Allows proper movement upward" do
      chess = Chess.new
      piece = chess.find_pieces('W')[0]
      expect(piece).to eq ['P', 6, 0]
      expect(chess.check_piece_moves(piece, 'W')).to eq [[5,0], [4,0]]
    end
  end
  context "For black pawn" do
    it "Allows proper movement downward" do
      chess = Chess.new
      piece = chess.find_pieces('B')[9]
      expect(piece).to eq ['P', 1, 1]
      expect(chess.check_piece_moves(piece, 'B')).to eq [[2,1], [3,1]]
    end
  end
end

RSpec.describe Chess, '#find_knight_moves' do
  context "Works for either color" do
    it "Works for white knights" do
      chess = Chess.new
      piece = chess.find_pieces('W')[9]
      expect(piece).to eq ['N', 7, 1]
      expect(chess.find_knight_moves(piece, 'W').sort).to eq [[5,0], [5,2]]
    end
    it "Works for black knights" do
      chess = Chess.new
      piece = chess.find_pieces('B')[6]
      expect(piece).to eq ['N', 0, 6]
      expect(chess.find_knight_moves(piece, 'B').sort).to eq [[2,5], [2,7]]
    end
  end
end

RSpec.describe Chess, '#find_horiz_vert_line_moves' do
  context "Will check all directions of horizontal or vertical lines" do
    it "Won't show any valid moves for a rook in an initial board" do
      chess = Chess.new
      piece = chess.find_pieces('W')[8]
      expect(piece).to eq ['R', 7, 0]
      expect(chess.find_horiz_vert_line_moves(piece, 'W')).to eq []
    end

    it "Will show valid horizontal or vertical moves for a rook or queen" do
      test_board = [
        ['BR','BN','BB','BK','EE','BB','BN','BR'],
        ['BP','BP','BP','BP','EE','BP','BP','BP'],
        ['EE','EE','EE','EE','EE','EE','EE','EE'],
        ['EE','EE','EE','EE','BP','EE','BQ','EE'],
        ['WP','EE','EE','EE','EE','EE','EE','EE'],
        ['EE','EE','EE','EE','EE','EE','EE','EE'],
        ['EE','WP','WP','WP','WP','WP','WP','WP'],
        ['WR','WN','WB','WK','WQ','WB','WN','WR']
      ]
      chess = Chess.new(test_board)
      piece1 = chess.find_pieces('W')[8]
      expect(piece1).to eq ['R', 7, 0]
      expect(chess.find_horiz_vert_line_moves(piece1, 'W')).to eq [[6,0], [5,0]]
      piece2 = chess.find_pieces('B')[15]
      expect(piece2).to eq ['Q', 3, 6]
      expect(chess.find_horiz_vert_line_moves(piece2, 'B').sort).to eq [[2,6], [3,5], [3,7],[4,6],[5,6],[6,6]]
    end
  end
end

RSpec.describe Chess, '#find_diagonal_line_moves' do
  context "Will check all directions of diagonal lines" do
    it "Won't show any valid moves for a bishop in an initial board" do
      chess = Chess.new
      piece = chess.find_pieces('W')[10]
      expect(piece).to eq ['B', 7, 2]
      expect(chess.find_diagonal_line_moves(piece, 'W')).to eq []
    end

    it "Will show valid diagonal moves for a bishop or queen" do
      test_board = [
        ['BR','BN','BB','BK','EE','BB','BN','BR'],
        ['BP','BP','BP','BP','EE','BP','BP','BP'],
        ['EE','EE','EE','EE','EE','EE','EE','EE'],
        ['EE','EE','EE','EE','BP','EE','BQ','EE'],
        ['EE','WP','EE','EE','EE','EE','EE','EE'],
        ['EE','EE','EE','EE','EE','EE','EE','EE'],
        ['WP','EE','WP','WP','WP','WP','WP','WP'],
        ['WR','WN','WB','WK','WQ','WB','WN','WR']
      ]
      chess = Chess.new(test_board)
      piece1 = chess.find_pieces('W')[10]
      expect(piece1).to eq ['B', 7, 2]
      expect(chess.find_diagonal_line_moves(piece1, 'W')).to eq [[6,1], [5,0]]
      piece2 = chess.find_pieces('B')[15]
      expect(piece2).to eq ['Q', 3, 6]
      expect(chess.find_diagonal_line_moves(piece2, 'B')).to eq [[2,5],[1,4],[2,7],[4,5],[5,4],[6,3],[4,7]]
    end
  end
end

RSpec.describe Chess, '#find_king_moves' do
  context "Will check all moves for a king" do
    it "Won't show any valid moves for a king in an initial board" do
      chess = Chess.new
      piece = chess.find_pieces('W')[11]
      expect(piece).to eq ['K', 7, 3]
      expect(chess.find_king_moves(piece, 'W')).to eq []
    end

    it "Will show valid moves for a king" do
      test_board = [
        ['BR','BN','BB','BK','EE','BB','BN','BR'],
        ['BP','BP','BP','BP','EE','BP','BP','BP'],
        ['EE','EE','EE','EE','EE','EE','EE','EE'],
        ['EE','EE','EE','EE','BP','EE','BQ','EE'],
        ['EE','WP','EE','EE','EE','EE','EE','EE'],
        ['EE','EE','EE','EE','EE','EE','EE','EE'],
        ['WP','EE','WP','WP','WP','WP','WP','WP'],
        ['WR','WN','WB','WK','WQ','WB','WN','WR']
      ]
      chess = Chess.new(test_board)
      piece1 = chess.find_pieces('B')[3]
      expect(piece1).to eq ['K', 0, 3]
      expect(chess.find_king_moves(piece1, 'B')).to eq [[0,4],[1,4]]
    end
  end
end

RSpec.describe Chess, '#find_queen_moves' do
  context "Will check all moves for a queen" do
    it "Won't show any valid moves for a queen in an initial board" do
      chess = Chess.new
      piece = chess.find_pieces('W')[12]
      expect(piece).to eq ['Q', 7, 4]
      expect(chess.find_queen_moves(piece, 'W')).to eq []
    end

    it "Will show valid moves for a queen" do
      test_board = [
        ['BR','BN','BB','BK','EE','BB','BN','BR'],
        ['BP','BP','BP','BP','EE','BP','BP','BP'],
        ['EE','EE','EE','EE','EE','EE','EE','EE'],
        ['EE','EE','EE','EE','BP','EE','BQ','EE'],
        ['EE','WP','EE','EE','EE','EE','EE','EE'],
        ['EE','EE','EE','EE','EE','EE','EE','EE'],
        ['WP','EE','WP','WP','WP','WP','WP','WP'],
        ['WR','WN','WB','WK','WQ','WB','WN','WR']
      ]
      chess = Chess.new(test_board)
      piece1 = chess.find_pieces('B')[15]
      expect(piece1).to eq ['Q', 3, 6]
      expect(chess.find_queen_moves(piece1, 'B').sort).to eq [[1,4],[2,5],[2,6],
      [2,7],[3,5],[3,7],[4,5],[4,6],[4,7],[5,4],[5,6],[6,3],[6,6]]
    end
  end
end
