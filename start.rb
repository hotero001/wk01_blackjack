#encoding: UTF-8

require "pry"

def get_shuffled_deck()
  suits = [:heart, :diamond, :spade, :club]
  cards = [2,3,4,5,6,7,8,9,10, :jack, :queen, :king, :ace]

  deck = suits.product(cards)

  j = 0
  (1..4).each do 
    (0..8).each { |i| deck[j] << (i + 2) && j += 1 }
    (9..11).each { deck[j] << 10 && j += 1 }
    deck[j] << 1
    j += 1
  end

 deck.shuffle!
end

p get_shuffled_deck



