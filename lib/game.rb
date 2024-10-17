require_relative 'board.rb'

class Game

  attr_reader :turn_counter

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2

    @turn_counter = 0
    @board = Board.new
  end

  def play_game

    choose_first_player
    board.print_board

    until win? || draw?
      self.turn_counter += 1
      board.print_board
      check_and_choose_field

      if win? || draw?
        board.print_board
        announce_result
        break
      else
        puts "\nIt's #{get_current_player.name}'s turn!"
      end
      switch_players!
    end
  end

  def get_current_player
    current_player
  end

  def get_other_player
    other_player
  end


  private

  attr_reader :player1, :player2
  attr_accessor :current_player, :other_player, :board, :winner
  attr_writer :turn_counter

  def choose_first_player
    if rand(1..2) == 1
      self.current_player = player1
      self.other_player = player2
    else
      self.current_player = player2
      self.other_player = player1
    end
    puts "\n#{current_player.name} with mark type #{current_player.mark_type} goes first!\n"
  end

  def switch_players!
    self.current_player, self.other_player = self.other_player, self.current_player
  end

  def win?
    board.win?(current_player.mark_type)
  end

  def draw?
    if self.turn_counter >= 42
     return true
    else
      return false
    end
  end

  def check_and_choose_field

    puts "Please choose a free row between (01-07) to drop your mark (#{self.current_player.mark_type}): "
    chosen_row = nil
    
    until valid_field?(chosen_row)
      chosen_row = gets.chomp
  
      unless valid_field?(chosen_row)
        puts "Your input is invalid or the field is already taken. Please enter a different number between 01-07: "
      end
    end
    board.drop_mark(chosen_row, self.current_player.mark_type)
  end

  def valid_field?(chosen_row)
    board.current_board[0].flatten.include?(chosen_row) && !board.full_row?(chosen_row)
  end

  def announce_result
    if win? 
      puts "#{current_player.name } wins!"
    else 
      puts "It's a draw!"
    end
  end
end