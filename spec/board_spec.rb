require_relative '../lib/board.rb'

RSpec.describe Board do

  subject(:board) { described_class.new }
  let(:player1) { double("Player1", name: "player one", mark_type: "XX")}
  let(:player2) { double("Player2", name: "player two", mark_type: "OO")}
  
  let(:initial_board) {[
    ["01", "02", "03", "04", "05", "06", "07"],
    ["08", "09", "10", "11", "12", "13", "14"],
    ["15", "16", "17", "18", "19", "20", "21"],
    ["22", "23", "24", "25", "26", "27", "28"],
    ["29", "30", "31", "32", "33", "34", "35"],
    ["36", "37", "38", "39", "40", "41", "42"]
  ]}

  let(:expected_empty_output) do
    "\n01 | 02 | 03 | 04 | 05 | 06 | 07\n" +
    "---+----+----+----+----+----+----\n" +
    "08 | 09 | 10 | 11 | 12 | 13 | 14\n" +
    "---+----+----+----+----+----+----\n" +
    "15 | 16 | 17 | 18 | 19 | 20 | 21\n" +
    "---+----+----+----+----+----+----\n" +
    "22 | 23 | 24 | 25 | 26 | 27 | 28\n" +
    "---+----+----+----+----+----+----\n" +
    "29 | 30 | 31 | 32 | 33 | 34 | 35\n" +
    "---+----+----+----+----+----+----\n" +
    "36 | 37 | 38 | 39 | 40 | 41 | 42\n"
  end

  describe "#initialize" do
    context "when a new Board instance is created" do

      it "current_board equals initial board" do
        expect(board.current_board).to eql(initial_board)
      end
    end
  end

  describe "#print_board" do
    context "when no player chose where to put a mark yet" do
      it "prints an empty board" do
        expect { board.print_board }.to output(expected_empty_output).to_stdout
      end
    end
  end

  describe "#full_row?" do
    describe "when the board is empty" do
      let(:empty_board) do
        [
          ["01", "02", "03", "04", "05", "06", "07"],
          ["08", "09", "10", "11", "12", "13", "14"],
          ["15", "16", "17", "18", "19", "20", "21"],
          ["22", "23", "24", "25", "26", "27", "28"],
          ["29", "30", "31", "32", "33", "34", "35"],
          ["36", "37", "38", "39", "40", "41", "42"]
        ]
      end

      before do
        allow(board).to receive(:current_board).and_return(empty_board)
      end

      context "when giving it a chosen field" do
        it "returns false when the row is not full" do
          chosen_field = "01"
          expect(board.full_row?(chosen_field)).to be false
        end
      end
  end

  describe "when the board is full" do
    let(:full_board) do
      [
        ["XX", "02", "03", "04", "05", "06", "07"],
        ["XX", "09", "10", "11", "12", "13", "14"],
        ["XX", "16", "17", "18", "19", "20", "21"],
        ["XX", "23", "24", "25", "26", "27", "28"],
        ["XX", "30", "31", "32", "33", "34", "35"],
        ["XX", "37", "38", "39", "40", "41", "42"]
      ]
    end

    before do
      allow(board).to receive(:current_board).and_return(full_board)
    end

    context "when giving it a chosen field in a full column" do
      it "returns true when the column is full" do
        chosen_field = "01"  # Spalte 1 ist voll, weil "XX" in der obersten Zeile ist
        expect(board.full_row?(chosen_field)).to be true
      end
    end

    context "when giving it a chosen field in a non-full column" do
      it "returns false when the column is not full" do
        chosen_field = "02"  # Spalte 2 ist nicht voll, "02" steht noch in der obersten Reihe
        expect(board.full_row?(chosen_field)).to be false
      end
    end
  end
end

  describe "#drop_mark" do
    context "when dropping a mark" do

      let(:initial_board) do
        [
          ["XX", "02", "03", "04", "05", "06", "07"],
          ["XX", "09", "10", "11", "12", "13", "14"],
          ["XX", "16", "XX", "18", "19", "20", "21"],
          ["XX", "23", "XX", "25", "26", "27", "28"],
          ["XX", "30", "XX", "32", "33", "34", "35"],
          ["XX", "37", "OO", "39", "40", "41", "42"]
        ]
      end

      before do
        allow(board).to receive(:current_board).and_return(initial_board)
        allow(board).to receive(:update_board!).and_call_original
      end

      it "calculates where the mark lands" do

        expected_board = [
          ["XX", "02", "03", "04", "05", "06", "07"],
          ["XX", "09", "PP", "11", "12", "13", "14"],
          ["XX", "16", "XX", "18", "19", "20", "21"],
          ["XX", "23", "XX", "25", "26", "27", "28"],
          ["XX", "30", "XX", "32", "33", "34", "35"],
          ["XX", "37", "OO", "39", "40", "41", "42"]
        ]

        chosen_row = "03"
        mark_type = "PP"

        board.drop_mark(chosen_row, mark_type)
        expect(board.current_board).to eq(expected_board)
      end
    end
  end

  describe "#update_board" do
    context "when calling update_board with a chosen field number and a mark type" do

      let(:chosen_field) {"02"}
      let(:mark_type) {"P1"}


      it "updates the board on the correct field" do
        board.update_board!(chosen_field, mark_type)
        expect(board.current_board[0][1]).to eq(mark_type)
      end

      it "does not change the board if the chosen field does not exist" do
        invalid_field = "43"

        board.update_board!(invalid_field, mark_type)
        expect(board.current_board).to eq(initial_board)
      end
      
      it "does not accept integers as the chosen_field" do
        invalid_field = 1

        board.update_board!(invalid_field, mark_type)
        expect(board.current_board).to eq(initial_board)
      end

      it "also accepts single integers as the mark_type" do

        mark_type = "P1"
        expected_board = [
          ["01", "P1", "03", "04", "05", "06", "07"],
          ["08", "09", "10", "11", "12", "13", "14"],
          ["15", "16", "17", "18", "19", "20", "21"],
          ["22", "23", "24", "25", "26", "27", "28"],
          ["29", "30", "31", "32", "33", "34", "35"],
          ["36", "37", "38", "39", "40", "41", "42"]
        ]
      
        board.update_board!(chosen_field, mark_type)
        expect(board.current_board).to eq(expected_board)
      end

      it "also accepts long integers as the mark_type" do

        mark_type = 0233222
        expected_board = [
          ["01", 0233222, "03", "04", "05", "06", "07"],
          ["08", "09", "10", "11", "12", "13", "14"],
          ["15", "16", "17", "18", "19", "20", "21"],
          ["22", "23", "24", "25", "26", "27", "28"],
          ["29", "30", "31", "32", "33", "34", "35"],
          ["36", "37", "38", "39", "40", "41", "42"]
        ]
      
        board.update_board!(chosen_field, mark_type)
        expect(board.current_board).to eq(expected_board)
      end

      it "also accepts longer strings as the mark_type" do

        mark_type = "alge"
        expected_board = [
          ["01", "alge", "03", "04", "05", "06", "07"],
          ["08", "09", "10", "11", "12", "13", "14"],
          ["15", "16", "17", "18", "19", "20", "21"],
          ["22", "23", "24", "25", "26", "27", "28"],
          ["29", "30", "31", "32", "33", "34", "35"],
          ["36", "37", "38", "39", "40", "41", "42"]
        ]

        board.update_board!(chosen_field, mark_type)
        expect(board.current_board).to eq(expected_board)
      end

      it "accepts any string as the mark_type" do
        
        mark_type = "§$§5"
        expected_board = [
          ["01", "§$§5", "03", "04", "05", "06", "07"],
          ["08", "09", "10", "11", "12", "13", "14"],
          ["15", "16", "17", "18", "19", "20", "21"],
          ["22", "23", "24", "25", "26", "27", "28"],
          ["29", "30", "31", "32", "33", "34", "35"],
          ["36", "37", "38", "39", "40", "41", "42"]
        ]

        board.update_board!(chosen_field, mark_type)
        expect(board.current_board).to eq(expected_board)
      end

      it "can not change the value of a field after creating the instance" do
        initial_mark_type = "P1"
        new_mark_type = "P2"

        board.update_board!(chosen_field, initial_mark_type)
        board.update_board!(chosen_field, new_mark_type)

        expect(board.current_board[0][1]).to eql(initial_mark_type)  
      end
    end
  end

  describe "#win?" do

    before do
      allow(board).to receive(:check_horizontal_win)
      allow(board).to receive(:check_vertical_win)
      allow(board).to receive(:check_diagonal_win)
    end

    context "when calling win?" do
      it "calls check_horizontal_win" do
        board.win?(player1.mark_type) 
        expect(board).to have_received(:check_horizontal_win)
      end

      it "calls check_vertical_win" do
        board.win?(player1.mark_type) 
        expect(board).to have_received(:check_vertical_win)
      end

      it "calls check_diagonal_win" do
        board.win?(player1.mark_type) 
        expect(board).to have_received(:check_diagonal_win)
      end
    end
  end

  describe "#check_horizontal_win" do
    context "when it iterates over the board" do

      it "returns true when there are 4 of the same symbol horizontally" do
        horizontal_win_board = [
          ["XX", "XX", "03", "XX", "XX", "XX", "XX"],
          ["08", "09", "10", "11", "12", "13", "14"],
          ["15", "16", "17", "18", "19", "20", "21"],
          ["22", "23", "24", "25", "26", "27", "28"],
          ["29", "30", "31", "32", "33", "34", "35"],
          ["36", "37", "38", "39", "40", "41", "42"]
        ]
        result = board.check_horizontal_win(player1.mark_type, horizontal_win_board)
        expect(result).to be true
      end

      it "returns true when there are more than 4 of the same symbol horizontally" do
        five_horizontal_win_board = [
          ["XX", "XX", "XX", "XX", "XX", "06", "07"],
          ["08", "09", "10", "11", "12", "13", "14"],
          ["15", "16", "17", "18", "19", "20", "21"],
          ["22", "23", "24", "25", "26", "27", "28"],
          ["29", "30", "31", "32", "33", "34", "35"],
          ["36", "37", "38", "39", "40", "41", "42"]
        ] 
        result = board.check_horizontal_win(player1.mark_type, five_horizontal_win_board)
        expect(result).to be true
      end

      it "returns false when there are 4 of the same symbol horizontally but not consecutive" do
        no_horizontal_win_board = [
          ["XX", "XX", "03", "XX", "XX", "06", "07"],
          ["08", "09", "10", "11", "12", "13", "14"],
          ["15", "16", "17", "18", "19", "20", "21"],
          ["22", "23", "24", "25", "26", "27", "28"],
          ["29", "30", "31", "32", "33", "34", "35"],
          ["36", "37", "38", "39", "40", "41", "42"]
        ]
        result = board.check_horizontal_win(player1.mark_type, no_horizontal_win_board)
        expect(result).to be false
      end

      it "returns true when there are 4 of the same symbol horizontally more than once" do
        multiple_horizontal_wins_board = [
        ["XX", "XX", "03", "XX", "XX", "06", "07"],
        ["08", "09", "10", "11", "12", "13", "14"],
        ["15", "XX", "XX", "XX", "XX", "20", "21"],
        ["22", "23", "24", "25", "26", "27", "28"],
        ["29", "30", "31", "32", "33", "34", "35"],
        ["36", "37", "XX", "XX", "XX", "XX", "42"]
      ]
        result = board.check_horizontal_win(player1.mark_type, multiple_horizontal_wins_board)
        expect(result).to be true
      end
    end
  end

  describe "#check_vertical_win" do
    context "when it iterates over the board" do

      it "returns true when there are 4 of the same symbol vertically" do
        vertical_win_board = [
          ["XX", "02", "03", "04", "05", "06", "07"],
          ["XX", "09", "10", "11", "12", "13", "14"],
          ["XX", "16", "17", "18", "19", "20", "21"],
          ["XX", "23", "24", "25", "26", "27", "28"],
          ["29", "30", "31", "32", "33", "34", "35"],
          ["36", "37", "38", "39", "40", "41", "42"]
        ] 
        result = board.check_vertical_win(player1.mark_type, vertical_win_board)
        expect(result).to be true
      end

      it "returns true when there are more than 4 of the same symbol vertically" do
        six_vertical_win_board = [
          ["01", "XX", "03", "04", "05", "06", "07"],
          ["08", "XX", "10", "11", "12", "13", "14"],
          ["15", "XX", "17", "18", "19", "20", "21"],
          ["22", "XX", "24", "25", "26", "27", "28"],
          ["29", "XX", "31", "32", "33", "34", "35"],
          ["36", "XX", "38", "39", "40", "41", "42"]
        ] 
        result = board.check_vertical_win(player1.mark_type, six_vertical_win_board)
        expect(result).to be true
      end

      it "returns false when there are 4 of the same symbol horizontally but not consecutive" do
        no_vertical_win_board = [
          ["01", "XX", "03", "04", "05", "06", "07"],
          ["08", "XX", "10", "11", "12", "13", "14"],
          ["15", "16", "17", "18", "19", "20", "21"],
          ["22", "XX", "24", "25", "26", "27", "28"],
          ["29", "XX", "31", "32", "33", "34", "35"],
          ["36", "XX", "38", "39", "40", "41", "42"]
        ] 
        result = board.check_vertical_win(player1.mark_type, no_vertical_win_board)
        expect(result).to be false
      end

      it "returns true when there are more than once 4 of the same symbol horizontally" do
        vertical_win_board = [
          ["01", "02", "XX", "04", "05", "06", "07"],
          ["08", "09", "XX", "11", "12", "13", "XX"],
          ["15", "16", "XX", "18", "XX", "20", "XX"],
          ["22", "23", "XX", "25", "XX", "27", "28"],
          ["29", "30", "31", "32", "XX", "34", "35"],
          ["36", "37", "38", "39", "XX", "41", "42"]
        ] 
        result = board.check_vertical_win(player1.mark_type, vertical_win_board)
        expect(result).to be true
      end
    end
  end

  describe "#check_diagonal_win" do
    context "when it iterates over the board" do

      it "returns true when there are 4 of the same symbol diagonally" do #links oben rechts unten
        diagonal_win_board = [
          ["XX", "02", "03", "04", "05", "06", "07"],
          ["08", "XX", "10", "11", "12", "13", "14"],
          ["15", "16", "XX", "18", "19", "20", "21"],
          ["22", "23", "24", "XX", "26", "27", "28"],
          ["29", "30", "31", "32", "33", "34", "35"],
          ["36", "37", "38", "39", "40", "41", "42"]
        ] 
        result = board.check_diagonal_win(player1.mark_type, diagonal_win_board)
        expect(result).to be true
      end

      it "returns true when there are 4 of the same symbol diagonally" do #links oben rechts unten
        diagonal_win_board = [
          ["XX", "02", "03", "04", "05", "06", "07"],
          ["08", "XX", "10", "11", "12", "13", "14"],
          ["15", "16", "XX", "18", "19", "20", "21"],
          ["22", "23", "24", "XX", "26", "27", "28"],
          ["29", "30", "31", "32", "XX", "34", "35"],
          ["", "37", "38", "39", "40", "XX", "42"]
        ]  
        result = board.check_diagonal_win(player1.mark_type, diagonal_win_board)
        expect(result).to be true
      end

      it "returns false when there are 4 of the same symbol diagonally but not consecutive" do #links oben rechts unten
        no_diagonal_win_board = [
          ["XX", "02", "03", "04", "05", "06", "07"],
          ["08", "XX", "10", "11", "12", "13", "14"],
          ["15", "16", "17", "18", "19", "20", "21"],
          ["22", "23", "24", "XX", "26", "27", "28"],
          ["29", "30", "31", "32", "XX", "34", "35"],
          ["", "37", "38", "39", "40", "41", "42"]
        ]  
        result = board.check_diagonal_win(player1.mark_type, no_diagonal_win_board)
        expect(result).to be false
      end

      it "returns true when there are more than once 4 of the same symbol diagonally" do
          diagonal_win_board = [
        ["01", "02", "03", "04", "05", "06", "07"],
        ["08", "09", "XX", "11", "12", "13", "14"],
        ["15", "16", "17", "XX", "19", "20", "21"],
        ["22", "23", "XX", "25", "XX", "27", "28"],
        ["29", "XX", "31", "32", "33", "XX", "35"],
        ["XX", "37", "38", "39", "40", "41", "42"]
        ] 
        result = board.check_diagonal_win(player1.mark_type, diagonal_win_board)
        expect(result).to be true
      end
    end
  end
end

#noch testen: dass beim ersten true returned wird bei win?