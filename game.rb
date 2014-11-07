require 'pry'
CARD_VALUES = {two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7, eight: 8, nine: 9, ten: 10, jack: 10, queen: 10, king: 10, ace: 11}

class Deck
  include ShuffleDeck
  include Cuttable

  def initialize
    card_ranks = ["two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "jack", "queen", "king", "ace"]
    card_suits = ["hearts", "diamonds", "clubs", "spades"]
    card_ranks.product(card_suits)
  end

end

class Player
  attr_accessor :name

  def initialize(name)
    puts "Hello #{name}!"
  end
end

class Dealer
  def initialize
    puts "Hello, my name is McApple, and I am your dealer!"
  end
end

class Blackjack

  def intialize(player, dealer, values, hand_value=0)
  end

  def get_hand_value(player, values)
    player_card_values = []
    player.each do |card|
      values.each do |k, v|
        if card[0] == k.to_s
          player_card_values << v
        end
      end
    end
    hand_value = 0
    player_card_values.each do |value|
      hand_value += value
    end
    #change ace value to 1 if need be
    if (player_card_values.include?(11)) && (hand_value > 21)
      hand_value = hand_value - 10
    end
    return hand_value
  end

  def blackjack?(hand_value)
    hand_value == 21 ? true : false
  end

  def bust?(hand_value)
    hand_value > 21 ? true : false
  end
end

module Dealable
  def deal_two_cards_each(deck, player, dealer)
    2.times do |card|
     player << deck.shift
     dealer << deck.shift
    end
  end

  def deal_player_one_card(deck, player)
    player << deck.shift
  end
end

module ShuffleDeck
  def intialize(deck)
    deck.shuffle!
  end
end

module Cuttable
end

module GamePlay
  include Dealable
  
  def play
  end
end
