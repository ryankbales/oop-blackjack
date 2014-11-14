require 'pry'
require_relative 'game_methods'
CARD_VALUES = {two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7, eight: 8, nine: 9, ten: 10, jack: 10, queen: 10, king: 10, ace: 11}

class Deck
  attr_accessor :cards

  def initialize
    card_ranks = ["two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "jack", "queen", "king", "ace"]
    card_suits = ["hearts", "diamonds", "clubs", "spades"]
    @cards = card_ranks.product(card_suits)
  end

  def shuffle_five_times
    5.times { @cards.shuffle! }
  end

  def cut
  end
end

class Player
  include Dealable, Handable, HitStay, Valuable
  attr_accessor :name, :hand, :funds
  def initialize(name="", hand=[], funds=500)
    puts "Welcome, what is your name?"
    name = gets.chomp.capitalize
    @name = name
    @hand = hand
    @funds = funds
  end

  def turn(players_hand, hand_value, cards, values)
    play_status = true
    while play_status
      puts "You have #{hand_value}"
      puts "================="
      play = hit_or_stay?
      if play
        player_hand = deal_player_one_card(cards, players_hand)
        hand_value = get_hand_value(player_hand, values)
        hand_status = check_hand(hand_value)
        case hand_status
        when 'blackjack'
          puts "================="
          show_hand(player_hand)
          puts "#{hand_value}!, you have Blackjack!  Dealers turn."
          puts "================="
          play_status = false
          return hand_value
        when 'bust'
          puts "================="
          show_hand(player_hand)
          puts "You have #{hand_value}, you Bust :("
          puts "================="
          play_status = false
          return hand_value
        when hand_status == false
          turn(players_hand, hand_value, cards)
        end
      else
        puts "================="
        puts "You have decided to stay with #{hand_value}, good luck!"
        puts "================="
        return hand_value
      end
    end
  end
end

class Dealer
  include Dealable, Handable, Valuable
  attr_reader :name, :hand
  def initialize(name='McApple', hand=[])
    puts "Hello, my name is McApple, and I am your dealer!"
    @name = name
    @hand = hand
  end

  def turn(dealers_hand, hand_value, cards, values)
    puts "Dealer has #{hand_value}"
    if (hand_value < 17)
      while hand_value < 17
        sleep 1
        puts "Dealer hits."
        puts "=============="
        deal_player_one_card(cards, dealers_hand)
        puts "Dealers cards:"
        puts "=============="
        show_hand(dealers_hand)
        puts "=============="
        hand_value = get_hand_value(dealers_hand, values)
        puts "Dealer has #{hand_value}"
        puts "=============="
      end
      if hand_value <= 21
        return hand_value
      else
        puts "Dealer Busts, You win!"
        return hand_value
      end
    elsif hand_value == 17
      puts "=============="
      puts "Dealer has 17 and stays"
      puts "=============="
      return hand_value
    elsif (hand_value > 17) && (hand_value < 21)
      puts "=============="
      puts "Dealers cards:"
      show_hand(dealers_hand)
      puts "=============="
      puts "Dealer stays at #{hand_value}"
      puts "=============="
      return hand_value
    end
  end
end

class Game
  attr_accessor :player

  def initialize

  end

  def play
    puts "Lets play #{self.class.to_s}!"
  end

  def play_again?
    game_name = self.class.to_s
    puts "Would you like to play #{self.class.to_s} again? Yes or No?"
    response = gets.chomp.downcase
    if response == "yes"
      system 'clear'
      return true
    elsif response == "no"
      system 'clear'
      return false
    else
      puts "Invalid input, please enter Yes or No?"
      play_again?
    end
  end
end

class Blackjack < Game
  include Valuable, Dealable
  attr_accessor :deck, :dealer, :player

  def initialize(dealer=Dealer.new, deck=Deck.new, player=Player.new(@name))
    @player = player
    @dealer = dealer
    @deck = deck
  end

  def play
    super
    cards = deck.cards
    player_hand = player.hand
    dealer_hand = dealer.hand
    deck.shuffle_five_times
    #Initial dealing of hands
    deal_two_cards_each(cards, player_hand, dealer_hand)
    player_hand_value = get_hand_value(player_hand)
    dealer_hand_value = get_hand_value(dealer_hand)
    #Check initial hands for blackjack or continue play
    player_has_blackjack = blackjack?(player_hand_value)
    dealer_has_blackjack = blackjack?(dealer_hand_value)

    #initial hand check

    if player_has_blackjack && !dealer_has_blackjack
      puts 'You have Blackjack! You win!'
      puts "Players cards:"
      player.show_hand(player_hand)
    elsif !player_has_blackjack && dealer_has_blackjack
      puts 'Dealer has Blackjack, you lose :('
      puts "Players cards:"
      player.show_hand(player_hand)
      puts "================"
      puts "Dealers cards:"
      dealer.show_hand(dealer_hand)
    elsif player_has_blackjack && dealer_has_blackjack
      puts "It's a Push! You both have 21."
      puts "Players cards:"
      player.show_hand(player_hand)
      puts "================"
      puts "Dealers cards:"
      dealer.show_hand(dealer_hand)
    else
      #continued gameplay
      puts "Players cards:"
      player.show_hand(player_hand)
      puts "================"
      puts "Dealers face up card:"
      dealer.show_one_card(dealer_hand)
      puts "================"

      #players turn
      player_hand_value = player.turn(player_hand, player_hand_value, cards, CARD_VALUES)

      #dealers turn, if player didn't bust already
      if player_hand_value <= 21
        dealer_hand_value = dealer.turn(dealer_hand, dealer_hand_value, cards, CARD_VALUES)
        if player_hand_value > dealer_hand_value
          puts "Player has #{player_hand_value}, Dealer has #{dealer_hand_value}. You win!"
        elsif (player_hand_value < dealer_hand_value) && (!bust?(dealer_hand_value))
          puts "Player has #{player_hand_value}, Dealer has #{dealer_hand_value}. You lose:("
        elsif (player_hand_value == dealer_hand_value) && (!bust?(dealer_hand_value)) && (!bust?(player_hand_value))
          puts "Player has #{player_hand_value}, Dealer has #{dealer_hand_value}.  It's a push!"
        end
      else
        puts "Looks like you busted, better luck next time."
      end
    end
  end
end

play_status = true
while play_status
  game = Blackjack.new
  game.play
  play_status = game.play_again?
end
