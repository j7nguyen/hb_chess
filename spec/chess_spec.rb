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
