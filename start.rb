#encoding: UTF-8

require "pry"

BLACK_JACK = 21
DEALERS_LIMIT = 17
ACE_MAX_VALUE = 11

def get_shuffled_deck()
  suits = [:♤, :♧, :♥, :♦]
  cards = [2, 3, 4, 5, 6, 7, 8, 9, 10, :j, :q, :k, :a]

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

def check_n_deck(deck)
  deck = get_shuffled_deck if deck.count == 0
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
    if card[2] == 1
      ace_in_hand += 1 
    else
      value += card[2]
    end
  end

  if ace_in_hand > 0
    if value == 9 && ace_in_hand == 2
      value += 12   # soft 12 #
    else
      value += ace_in_hand
    end
  end

  value
end

def is_computer_hits?(hand)
  true if value_in_hand(hand) < DEALERS_LIMIT
end


def check_exit_cases(hand, player, is_exit)
  
  if value_in_hand(hand) == BLACK_JACK
    player == :player ? puts("You wins!") : puts("Computer wins!")
    is_exit.replace "true"
    return true
  end

  if value_in_hand(hand) > BLACK_JACK
    player == :player ? puts("You are busted") : puts("Computer is busted")
    is_exit.replace "true"
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
end

def print_hands(players_hand, computers_hand)
  system "cls" or system "clear"
  puts 
  puts "COMPUTER: #{value_in_hand(computers_hand)}"
  computers_hand.each { |card| print_card(card) }
  puts
  puts "PLAYER: #{value_in_hand(players_hand)}"
  players_hand.each { |card| print_card(card) }
  puts
end

def hit_or_stay?
  begin
    puts "Do you want to hit or stay? (h/s)"
    choice = gets.chomp.downcase
  end until choice == "h" || choice == "s"
  if choice == "h"
    :hit
  else
    :stay
  end
end

##############
# PLAYGROUND #
##############

deck = []
is_exit = "false"

deck = get_shuffled_deck

begin

  players_hand = []
  computers_hand = []

  # small cheat - if the deck is almost empty - add another deck #
  deck << get_shuffled_deck if deck.count < 4
  2.times { players_hand << get_card(deck) && computers_hand << get_card(deck) }

  choice = :hit

  # Player's part #
  begin

    print_hands(players_hand, computers_hand)
    break if check_exit_cases(players_hand, :player, is_exit) 
    break if check_exit_cases(computers_hand, :computer, is_exit)
    
    choice = hit_or_stay?
          
    if choice == :hit
      
      check_n_deck(deck)
      players_hand << get_card(deck)

      print_hands(players_hand, computers_hand)
      break if check_exit_cases(players_hand, :player, is_exit)

    end

  end while choice == :hit

  # Computer's part #
  while is_exit == "false"

    if is_computer_hits?(computers_hand)

      check_n_deck(deck)
      computers_hand << get_card(deck)

      print_hands(players_hand, computers_hand)
      break if check_exit_cases(computers_hand, :computer, is_exit)

      if !is_computer_hits?(computers_hand)
        check_score(players_hand, computers_hand)
        break
      end

    else
      check_score(players_hand, computers_hand)
      break 
    end

  end

  is_exit = "false"
  puts "Do you want to play more? (y/n)"
end while gets.chomp.downcase == "y"