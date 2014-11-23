#encoding: UTF-8

require "pry"


BLACK_JACK = 21
DEALERS_LIMIT = 17
ACE_MAX_VALUE = 11

def get_shuffled_deck()
  suits = [:heart, :diamond, :spade, :club]
  cards = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]

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

def get_card(deck)
  deck.pop
end

def print_card(card)
  puts "  #{card[0].to_s.upcase} #{card[1].to_s.upcase}"
end

def value_in_hand(hand)
  value = 0
  ace_in_hand = 0
  hand.each do |card| 
    if card[2] == 1 && hand.count == 2
      value += 11
    elsif card[2] == 1 && hand.count > 2
      ace_in_hand += 1
    else
      value += card[2]
    end
  end
  if ace_in_hand > 0
    if value >= ACE_MAX_VALUE
      value += ace_in_hand
    else
      value += ACE_MAX_VALUE
    end
  end
  value
end

def is_hit?(hand)
  true if value_in_hand(hand) < DEALERS_LIMIT
end

def is_black_jack?(hand)
  true if value_in_hand(hand) == BLACK_JACK
end

def is_busted?(hand)
  true if value_in_hand(hand) > BLACK_JACK
end

def check_black_jack(players_hand, computers_hand)
  if is_black_jack?(computers_hand) && is_black_jack?(players_hand)
    puts "You both have Black Jack!"
    true
  end

  if is_black_jack?(computers_hand)
    puts("Computer wins!")
    return true 
  end

  if is_black_jack?(players_hand) 
    puts("You win!") 
    return true
  end
end

def check_busted(players_hand, computers_hand)
  if is_busted?(players_hand) 
    puts "You are busted"
    return true
  end

  if is_busted?(computers_hand)
    puts "Computer is busted"
    return true
  end
end

def check_score(players_hand, computers_hand)
  score = value_in_hand(players_hand) - value_in_hand(computers_hand) 
  if score > 0
    puts "You win by score"
  elsif score < 0
    puts "Computer wins by score"
  else
    puts "You have push"
  end
ends


###########
# POLYGON #
###########

deck = []
players_hand = []
computers_hand = []

deck = get_shuffled_deck

2.times { players_hand << get_card(deck) && computers_hand << get_card(deck) }

is_exit = false

begin
  puts "COMPUTER:"
  computers_hand.each { |card| print_card(card) }
  puts "Value = #{value_in_hand(computers_hand)}"
  puts
  puts "PLAYER:"
  players_hand.each { |card| print_card(card) }
  puts "Value = #{value_in_hand(players_hand)}"
  puts 

  is_exit = true if check_black_jack(players_hand, computers_hand)
  is_exit = true if check_busted(players_hand, computers_hand)
  if is_exit == false
    begin
      puts "Do you want to hit or stay? (h/s)"
      choice = gets.chomp.downcase
    end until choice == "h" || choice == "s"
    
    if choice == "h"
      players_hand << get_card(deck)
    else
      if is_hit?(computers_hand)
        computers_hand << get_card(deck) 
      else
        check_score(players_hand, computers_hand)
        is_exit = true
      end
    end
  end

end while is_exit == false

puts "END"




