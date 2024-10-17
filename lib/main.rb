require_relative "game.rb"
require_relative "player.rb"

puts "Player 1, please set your name!\nName:"
player1_name = gets.chomp

puts "Now you, Player 2! Please set your name.\nName: "
player2_name = gets.chomp

player1 = Player.new(player1_name, "XX")
player2 = Player.new(player2_name, "OO")


game = Game.new(player1, player2)
game.play_game