require 'colorize'


class Piece

	MOVE_OFFSETS = {
		white: [
			[1, 1], 
		  [1, -1], 
		  [2, 2], 
		  [2, -2]
		],

		red: [
			[-1, -1], 
			[-1, 1], 
			[-2, 2], 
			[-2, -2]
		]

	}
		
		

	attr_reader :color

	def initialize (board, color, position, king = false)
		@board = board
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

	def inspect
		to_s
	end

	def perform_slide(move)
		return false unless move_diffs.include?(move)
		@board[move] = self
        @board[@position] = nil
		@position = move
		true
	end

	def perform_jump(move)
		return false unless move_diffs.include?(move)
		position_to_remove = jumped_position(move)
		remove(position_to_remove)
		@board[@position] = nil
		@board[move] = self
		@position = move
		true
	end

	def move_diffs
		return validate(MOVE_OFFSETS.values.flatten(1)) if @king
		p MOVE_OFFSETS[@color]
		validate(MOVE_OFFSETS[@color])
	end

	def validate(offsets)
		moves = offsets.map {|move_offset| get_position(move_offset) }
		moves.select {|move| valid_move?(move)}
	end

	def get_position(offset)
		x,y = @position
		x2,y2 = offset
		[(x + x2), (y + y2)]
	end

	def valid_move?(move)
		return available?(move) if slide?(move)
		legal_jump?(move)
	end

	def slide?(move)
		(@position[0] - move[0]).abs == 1
	end

	def available?(pos)
		@board[pos].nil?
	end

	def legal_jump?(move)
		jumped_space = @board[jumped_position(move)]
		!jumped_space.nil? && jumped_space.color != @color
	end



	def jumped_position(move)
		x, y = @position
		x2, y2 = move
		[((x + x2) / 2), ((y + y2) / 2)]
	end

	def remove(pos)
		@board[pos] = nil
	end

end

class CheckerBoard

	STARTING_POSITIONS_WHITE = [
		[0,1],[0,3],[0,5],[0,7],[1,0],[1,2],
		[1,4],[1,6],[2,1],[2,3],[2,5],[2,7]
	]

	STARTING_POSITIONS_RED = [
		[7,0],[7,2],[7,4],[7,6],[6,1],[6,3],
		[6,5],[6,7],[5,0],[5,2],[5,4],[5,6]
	]

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
					display_string << space.to_s.colorize(space.color)
								.on_black unless space.nil?
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
			self[pos] = Piece.new(self, :white, pos)
		end
		STARTING_POSITIONS_RED.each do |pos|
			self[pos] = Piece.new(self, :red, pos)
		end
	end

	
  def inspect
    display_board
  end
end

