class String
  def red; "\e[31m#{self}\e[0m" end
  def green; "\e[32m#{self}\e[0m" end
end

class Game
	attr_accessor :turns, :secret_code, :player_guess

	def initialize
		@turns = 4
		display_instructions
		play_game
	end

	# Display functions
  def display_instructions
    puts "***************************************"
    puts "************ Instructions *************"
    puts "***************************************"
    puts "======================================="
    puts "3. Each time you enter your guesses...."
    puts "   The computer will give you some hints"
    puts "   on whether your guess had correct digit,"
    puts "   incorrect digits or correct digits"
    puts "   that are in the incorrect position\n "
    puts "***************************************"
    puts "*********** GUIDES TO HINTS ***********"
    puts "***************************************"
    puts "======================================="
    puts "1. If you get a digit correct and it is"
    puts "   in the correct position, the digit "
    puts "   will be colored #{"green".green}"
    puts "2. If you get a digit correct but in the"
    puts "   wrong position, the digit will be colored white"
    puts "3. If you get the digit incorrect, the "
    puts "   digit will be colored #{"red".red}\n "
    puts "For example:"
    puts "If the secret code is:"
    puts "1523"
    puts "and your guess was:"
    puts "1562"
    puts "You will see the following result:"
    puts "#{"15".green}#{"6".red}2"
    puts "1. You have to break the secret code in"
    puts "   order to win the game"
    puts "2. You are given 5 guesses to break the"
    puts "   code. The code ranges between 1 to 6"
    puts "   A number can be repeated more than once!"
  end

  # Real functions
  def generate_secret_code
  	@secret_code = []
  	for i in (0..3)
  		@secret_code[i] = (1 + rand(6)).to_s
  	end
  	# puts "Secret code is #{@secret_code}"
  end

  def get_guess
  	loop do
  		puts "******"
  		puts "Provide your guess for the code: (1-6)"
  		puts "You have rounds left: #{"#{@turns}".red}"

  		@player_guess = gets.chomp.split('')

  		break if validate_input(@player_guess)
  	end
  end

  def validate_input (input)
  	input.length == 4 && input.all? { |n| n.to_i >= 1 && n.to_i <= 6 }
  end

  def analyze_guess 
  	puts "Round results:"
  	print " "
  	for i in (0..3) do
  		if @secret_code[i] == @player_guess[i]
  			print @player_guess[i].green
  		elsif @secret_code.include?(@player_guess[i])
  			print @player_guess[i]
  		else
  			print @player_guess[i].red
  		end
  	end
  	puts ""
  end

  def game_won?
  	@secret_code == @player_guess
  end

	# Main
	def play_game
		generate_secret_code

		while @turns > 0 do
			get_guess
			analyze_guess
			@turns -= 1
			break if game_won?
		end

			if play_again? 
				Game.new
			else
				puts "Thank you for playing! Bye!"
			end
		end
		
	end

	def play_again?
		play_again = nil

		puts game_won? ? "Congratulations! You won!" : "You loose!"

		puts "The secret code was: #{@secret_code.join("")}"
		puts "Your final guess was: #{@player_guess.join("")}"

		loop do
			puts "Do you want to play again? (Y/N)"
			play_again = gets.chomp.upcase

			break if play_again == "Y" || play_again == "N"
		end

		play_again == "Y"

end

game = Game.new