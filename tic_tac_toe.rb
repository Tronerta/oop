class Board
	@@cells = [1, 2, 3, 4, 5, 6, 7, 8, 9]

	def update_board (cells = @@cells)
		# Split cells to rows by 3
		rows = cells.each_slice(3).to_a

		rows.each do |row|
			row.each_with_index do |cell, index|
				if index == row.length - 1 
					# If last cell - make new line
					puts " #{cell}"
				else
					print " #{cell} |"
				end
			end
			# If 1 or 2 row - puts separation line
			puts "---+---+---" if row != rows[-1]
		end
	end

end

class Game
	attr_accessor :cells, :winning_variants, :board,
	:player1, :player2, :current_player, :mark

	def initialize
		@cells = [1, 2, 3, 4, 5, 6, 7, 8, 9]
		@winning_variants = [
			[1, 2, 3], [4, 5, 6], 
			[7, 8, 9], [1, 4, 7],
			[2, 5, 8], [3, 6, 9],
			[1, 5, 9], [7, 5, 3]
		]
		display_instructions
		@board = Board.new
		play_game
	end

	def display_instructions
		p "*** Welcome to the Tic Tac Toe game! ***"
		p "****************************************"
	end

	def set_players_marks
		loop do
			puts "Player 1, choose your mark! ('X' or 'O')"
			@player1 = gets.chomp.upcase

			break if @player1 == 'X' || @player1 == 'O'
		end
		@player2 = @player1 == 'X' ? 'O' : 'X'
		p "Player 1 mark: #{@player1}, Player 2 mark: #{@player2}"
	end

	def turn
		loop do
			p "#{current_player_name}: Choose position to place your mark (#{@current_player})"
			@mark = gets.chomp.to_i

			break if @cells.include?(@mark)
		end
	end

	def current_player_name
		@current_player == @player1 ? "Player 1" : "Player 2"
	end

	def switch_player
		@current_player = @current_player == @player1 ? @player2 : @player1
	end

	def update_cells
		index = @cells.index(@mark)
		@cells[index] = @current_player
		@board.update_board(@cells)
	end

	def update_winning_variants
		# Switch all choosen cells to players mark
		@winning_variants.each do |variant|
			variant.map! { |cell| cell = cell == @mark ? @current_player : cell }
		end
	end

	def game_ended?
		def player_won?
			@winning_variants.any? do |variant|
				variant.all? { |cell| cell == @current_player }
			end
		end

		def draw?
			@cells.none? { |cell| cell.is_a? Integer } && !player_won?
		end

		p "It's a draw!" if draw?		
		p "#{current_player_name} won!" if player_won?

		player_won? || draw?
	end

	def play_again?
		answer = nil
		loop do
			p "Do you want to play again? (Y/N)"
			answer = gets.chomp.upcase	

			break if answer == "Y" || answer == "N"
		end
		answer == "Y"
	end

	# main
	def play_game
		set_players_marks
		@current_player = @player1
		@board.update_board

		loop do
			turn
			update_cells
			update_winning_variants
			break if game_ended?
			switch_player
		end

		play_again? ? Game.new : (p "Have a nice day!")
	end
end

play = Game.new