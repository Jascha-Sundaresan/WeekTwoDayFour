require 'colorize'

class Piece

	attr_reader :color

	def initialize (color, position, king = false)
		@color = color
		@position = position
		@king = king
	end

	def to_s
		if @king
			@color == :white ? "\u26C1" : "\u26C3"
		else
			@color == :white ? "\u26C0" : "\u26C2"
		end
	end

end

class CheckerBoard

	STARTING_POSITIONS_WHITE = [[0,1],[0,3],[0,5],[0,7],[1,0],[1,2],[1,4],[1,6],[2,1],[2,3],[2,5],[2,7]]
	STARTING_POSITIONS_RED = [[7,0],[7,2],[7,4],[7,6],[6,1],[6,3],[6,5],[6,7],[5,0],[5,2],[5,4],[5,6]]

	def initialize(populate = true)
		@board = Array.new(8) { Array.new(8) }
		populate_board if populate
	end

	def display_board
		display_string = ""

		alternate_color = false
		@board.each do |rows|
		  rows.each do |space|
		    if alternate_color
					display_string << " ".on_black if space.nil?
					display_string << space.to_s.colorize(space.color).on_black unless space.nil?
					display_string << " ".on_black
				else
					display_string << "  ".on_white
				end
			  alternate_color = !alternate_color
			end
		  display_string << "\n"
		  alternate_color = !alternate_color
	  end
	  puts display_string

	end


	private

	def [](position)
		x,y = position
		@board[x][y]
	end

	def []=(position, piece)
		x,y = position
		@board[x][y] = piece
	end

	def populate_board
		STARTING_POSITIONS_WHITE.each do |pos|
			self[pos] = Piece.new(:white, pos)
		end
		STARTING_POSITIONS_RED.each do |pos|
			self[pos] = Piece.new(:red, pos)
		end
	end


end

