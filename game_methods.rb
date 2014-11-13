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
  def cut
  end
end

module Valuable
  def get_hand_value(player, values=CARD_VALUES)
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
