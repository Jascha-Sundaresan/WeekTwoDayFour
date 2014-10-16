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
		return false unless move_diffs.include?(move) && slide?(move)
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

	def perform_moves!(move_seq)
		if move_seq.size == 1
			move = move_seq[0]
			raise InvalidMoveError.new unless 
			        (perform_slide(move) || perform_jump(move))
		else
			raise InvalidMoveError.new unless 
			         move_seq.all? { |move| perform_jump(move) }
		end
	end

	def perform_moves(move_seq)
		if valid_move_seq?(move_seq)
			perform_moves!(move_seq)
		else
			raise InvalidMoveError.new("invalid move")
		end
	end

	def valid_move_seq?(move_seq)
		begin
			self.dup.perform_moves!(move_seq)
		rescue InvalidMoveError
			false
		else
			true
		end
	end

	def dup
		Piece.new(@board.dup, @color, @position, @king)
	end



	def move_diffs
		offsets = @king ? MOVE_OFFSETS.values.flatten(1) : 
				MOVE_OFFSETS[@color]
		valid_moves(offsets)
	end

	def valid_moves(offsets)
		moves = offsets.map { |move_offset| get_position(move_offset) }
		moves.select { |move| valid_move?(move) }
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

	def king_check
		@king = true if in_opponent_crownhead?
	end

	def in_opponent_crownhead?
		(@color == :white && @position[0] == 7) || 
				(@color == :red && @position[0] == 0)
	end

end

