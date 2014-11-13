require 'pry'
require_relative 'game_methods'
CARD_VALUES = {two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7, eight: 8, nine: 9, ten: 10, jack: 10, queen: 10, king: 10, ace: 11}

class Deck
  include ShuffleDeck
  include Cuttable
  attr_accessor :deck
  def initialize(deck=[])
    card_ranks = ["two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "jack", "queen", "king", "ace"]
    card_suits = ["hearts", "diamonds", "clubs", "spades"]
    @deck = card_ranks.product(card_suits)
  end

end

class Player
  attr_accessor :name, :hand, :funds

  def initialize(name, hand=[], funds=500)
    @name = name
    @hand = hand
    @funds = funds
  end
end

class Dealer
  attr_reader :name, :hand
  def initialize(name='McApple', hand=[])
    puts "Hello, my name is McApple, and I am your dealer!"
    @name = name
    @hand = hand
  end
end

class Game
  attr_accessor :player

  def initialize

  end

  def play
    puts "Lets play #{self.uppercase}!"
  end

  def play_again?
    puts "Would you like to play again?"
    response = gets.chomp.downcase
    response == "yes" ? true : false
  end
end

class Blackjack < Game
  include Valuable
  include Dealable
  attr_accessor :deck, :dealer, :player
  puts "Welcome, what is your name?"
  name = gets.chomp.capitalize
  player = Player.new(name)
  dealer = Dealer.new
  deck = Deck.new
  def initialize(dealer, deck, player)
    @player = player
    @dealer = dealer
    @deck = deck
    puts "Hello #{self.player.name}!  Your dealer is #{self.dealer.name}"
  end

  deal_two_cards_each(deck, player.hand, dealer.hand)
  player_hand = player.hand
  dealer_hand = dealer.hand
  binding.pry
  get_hand_value(player_hand)
  get_hand_value(dealer_hand)
end

Blackjack.new.play
