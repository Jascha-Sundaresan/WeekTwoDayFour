class CheckerBoard

	attr_reader :board

	STARTING_POSITIONS_WHITE = [
		[0,1],[0,3],[0,5],[0,7],[1,0],[1,2],
		[1,4],[1,6],[2,1],[2,3],[2,5],[2,7]
	]

	STARTING_POSITIONS_RED = [
		[7,0],[7,2],[7,4],[7,6],[6,1],[6,3],
		[6,5],[6,7],[5,0],[5,2],[5,4],[5,6]
	]

	def initialize(populate = :normal)
		@board = Array.new(8) { Array.new(8) }
		if populate == :test
			populate_test_board
		elsif populate == :normal
			populate_board
		end
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

	def populate_test_board
		self[[1,0]] = Piece.new(self, :white, [1,0])
		self[[2,1]] = Piece.new(self, :red, [2,1])
		self[[4,3]] = Piece.new(self, :red, [4,3])
		self[[6,5]] = Piece.new(self, :red, [6,5])
	end

	
  def inspect
    display_board
  end

  def dup
  	duped_board = CheckerBoard.new(:empty)
  	8.times do |x|
  		8.times do |y|
  			duped_board[[x,y]] = self[[x,y]]
  		end
  	end
  	duped_board
   end

   def every_piece(color)
   	@board.flatten.select { |piece| !piece.nil? && piece.color == color }
   end
   
end

