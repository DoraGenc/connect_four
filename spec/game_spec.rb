require_relative "../lib/game.rb"


RSpec.describe Game do

  let(:player1) { double("Player1", name: "player one", mark_type: "X")} #instance doubles
  let(:player2) { double("Player2", name: "player two", mark_type: "O")}
  subject(:game) { described_class.new(player1, player2) }

  let(:fake_board) { double("Board") }

  before do
    allow(game).to receive(:gets).and_return("01")
  end

  describe "#initialize" do
    context "when initialize is called" do

      it "takes two player arguments and saves them as an instance variables" do #hier
        expect(game.instance_variable_get(:@player1)).to eq(player1)
        expect(game.instance_variable_get(:@player2)).to eq(player2)
      end

      it "sets turn_counter to 0" do
        expect(game.instance_variable_get(:@turn_counter)).to eql(0)
      end

      it "creates a new Board instance" do
        allow(Board).to receive(:new).and_call_original
        game = Game.new(player1, player2)
        expect(Board).to have_received(:new)
      end
    end

    context "when trying to change instance variables of a game instance" do
      it "raises a NoMethodError when changing player1" do
        new_player1 = "new player"
        expect { game.player1 = new_player1 }.to raise_error(NoMethodError)
      end

      it "raises a NoMethodError when changing player2" do
        new_player2 = "new player"
        expect { game.player1 = new_player2 }.to raise_error(NoMethodError)
      end

      it "raises a NoMethodError when changing turn_counter" do
        expect { game.turn_counter =+ 1 }.to raise_error(NoMethodError)
      end

      it "raises a NoMethodError when changing the board" do
        new_board = "new board"
        expect { game.board = new_board }.to raise_error(NoMethodError)
      end
    end

    context "when trying to read out instance variables" do
      it "can only read out the turn_counter" do
        expect(game).to respond_to(:turn_counter)
      end

      it "can not read out player1" do
        expect(game).not_to respond_to(:player1)
      end

      it "can not read out player2" do
        expect(game).not_to respond_to(:player2)
      end

      it "can not read out board" do
        expect(game).not_to respond_to(:board)
      end
    end
  end

  describe "#play_game" do
    context "when calling play_game the first time" do

      it "calls choose_first_player" do
        allow(game).to receive(:choose_first_player).and_call_original #damit wirklich player gesetzt werden
        game.play_game
        expect(game).to have_received(:choose_first_player)
      end

      it "only calls choose_first_player once" do
        allow(game).to receive(:choose_first_player)
        allow(game).to receive(:win?).and_return(true) #or the loop would continue
        game.play_game
        expect(game).to have_received(:choose_first_player).once
      end

      it "prints the board after calling choose_first_players" do 
        allow(game).to receive(:choose_first_player) 
        allow(game).to receive(:win?).and_return(true) 
        allow(game).to receive(:draw?).and_return(true)
        allow(game).to receive(:board).and_return(fake_board)
        allow(fake_board).to receive(:print_board)
        game.play_game
        expect(game).to have_received(:choose_first_player).ordered
        expect(fake_board).to have_received(:print_board).ordered
      end
    end

    context "when the game loop starts" do
      it "checks & breaks the play_game loop when win? == true" do
        allow(game).to receive(:win?).and_return(true)
        game.play_game
        expect(game).to have_received(:win?).once
      end

      it "checks & breaks the play_game loop when draw? == true" do
        allow(game).to receive(:draw?).and_return(true)
        game.play_game
        expect(game).to have_received(:draw?).once
      end
    end

    context "when win? and draw? return false (loop continues)" do

      before do
        allow(game).to receive(:win?).and_return(false, true)
        allow(game).to receive(:draw?).and_return(false, true)
      end

      it "increases the turn_counter by 1 once in every loop" do
        initial_turn_counter = game.turn_counter
        game.play_game  
        expect(game.turn_counter).to eq(initial_turn_counter + 1)
      end

      it "calls check_and_choose_field once in every loop" do
        allow(game).to receive(:check_and_choose_field)
        game.play_game
        expect(game).to have_received(:check_and_choose_field)
      end

      it "calls switch_players! once after check_and_choose field was called" do
        allow(game).to receive(:check_and_choose_field)
        allow(game).to receive(:switch_players!)
        game.play_game
        expect(game).to have_received(:check_and_choose_field).ordered
        expect(game).to have_received(:switch_players!).ordered
      end

      it "checks win? again" do
        game.play_game
        expect(game).to have_received(:win?).exactly(3).times
      end
    end

    context "when the loop breaks" do
      it "calls announce_result" do
        allow(game).to receive(:win?).and_return(true, true)
        allow(game).to receive(:announce_result)
        game.play_game
        expect(game).to have_received(:announce_result).once
      end
    end
  end

  describe "#choose_first_player" do
    context "when rand returns 1" do
      before do
        allow_any_instance_of(Game).to receive(:rand).and_return(1)
      end

      it "changes the current_player to player1" do
        game.send(:choose_first_player)
        expect(game.get_current_player).to eq(player1)
      end

      it "changes the other_player to player2" do
        game.send(:choose_first_player)
        expect(game.get_other_player).to eq(player2)
      end

      it "calls player1.name" do
        game.send(:choose_first_player)
        expect(player1).to have_received(:name)
      end

      it "does not call player2.name" do
        game.send(:choose_first_player)
        expect(player2).not_to have_received(:name)
      end
    end

    context "when rand returns 2" do
      before do
        allow_any_instance_of(Game).to receive(:rand).and_return(2)
      end

      it "changes the current_player to player1" do
        game.send(:choose_first_player)
        expect(game.get_current_player).to eq(player2)
      end

      it "changes the other_player to player2" do
        game.send(:choose_first_player)
        expect(game.get_other_player).to eq(player1)
      end

      it "calls player2.name" do
        game.send(:choose_first_player)
        expect(player2).to have_received(:name)
      end

      it "does not call player1.name" do
        game.send(:choose_first_player)
        expect(player1).not_to have_received(:name)
      end
    end
  end

  describe "#switch_players!" do
    before do 
      game.send(:choose_first_player)
      allow_any_instance_of(Game).to receive(:rand).and_return(1) #current_player = player1
    end

    context "when switch_players! is called" do
      it "changes the current_player to other_player" do
        current_player_before = game.get_current_player
        game.send(:switch_players!)
        expect(game.get_current_player).not_to eql(current_player_before)
      end

      it "changes the other_player to current_player" do
        other_player_before = game.get_other_player
        game.send(:switch_players!)
        expect(game.get_other_player).not_to eql(other_player_before)
      end
    end
  end
end

#gem