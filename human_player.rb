class HumanPlayer
	attr_reader :color

	def initialize(color, board)
		@color = color.to_sym
		@board = board
	end

	def out_of_moves?
		pieces = @board.every_piece(@color)
		pieces.all? do |piece|
			piece.move_diffs.empty?
		end 
	end

	def play_move
		begin
		  puts "enter move sequence eg '2,1 3,0'"
		  input = parse(gets.chomp)
		  piece_to_move = @board[input.first]
		  move_seq = input.drop(1)
		  raise InvalidMoveError.new("You don't have a piece there.") unless 
		  			your_piece?(piece_to_move)
		  piece_to_move.perform_moves(move_seq)
		rescue InvalidMoveError => e 
			puts e 
			retry
		end
			piece_to_move
	end

	def your_piece?(piece_to_move)
		piece_to_move && piece_to_move.color == @color
	end

	def parse(input)
		parsed = input.split
		parsed.map! { |pos| pos.split(",") }
		parsed.map! do |pos|
		  pos.map! do |point|
		    point.to_i
		  end
		end
		parsed
	end


end