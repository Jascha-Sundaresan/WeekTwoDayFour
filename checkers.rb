require 'colorize'
require_relative 'checkerboard'
require_relative 'checker_piece'
require_relative 'human_player'

class InvalidMoveError < StandardError; end
class CheckerGame

	def initialize
		@board = CheckerBoard.new
		@player1 = HumanPlayer.new(:red, @board)
		@player2 = HumanPlayer.new(:white, @board)
	end

	def play
		current_player = @player1
		until over?
			p @board
			current_player.play_move.king_check
			switch(current_player)
		end
		switch(current_player)
		congratulate(current_player)
	end

	def over?
		either_player.any?(&:out_of_moves?)
	end

	def either_player
		[@player1, @player2]
	end

	def switch(current_player)
		current_player = (current_player == @player1 ? @player2 : @player1)
	end

	def congratulate(current_player)
		puts "#{current_player.color} wins!"
	end

end