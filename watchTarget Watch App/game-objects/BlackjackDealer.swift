//
//  BlackjackDealer.swift
//  project
//
//  Created by Alexander Joseph Toskey on 2/23/26.
//

struct Deck {
    let suits: [Suit] = [.clubs, .spades, .hearts, .diamonds]
    let values: [FaceValue] = [.ace, .two, .three, .four, .five, .six, .seven, .eight, .nine, .ten, .jack, .queen, .king]
    var cards: [PlayingCard] = []

    init() {
        for suit in suits {
            for value in values {
                cards.append(PlayingCard(suit: suit, faceValue: value))
            }
        }
    }
}

class BlackjackDealer {
    
    var deck: Deck
    var betAmount: Int
    
    init(deck: Deck) {
        self.deck = deck
        betAmount = 0
        shuffle()
    }
    
    func toString() -> String {
        return deck.cards.map { "\($0.description())" }.joined(separator: ", ")
    }
    
    func shuffle() {
        deck.cards.shuffle()
    }
    
    func newDeck() {
        deck = Deck()
        shuffle()
    }
    
    func dealCard() -> PlayingCard? {
        return deck.cards.popLast()
    }
    
    func takeBet(amount: Int) {
        betAmount += amount
    }
    
    func assessHands(playerHand: [PlayingCard], dealerHand: [PlayingCard]) -> (playerScore: Int, dealerScore: Int) {
        var playerScore = 0
        var dealerScore = 0
        for card in playerHand {
            playerScore += card.value
            if playerScore > 21 {
                for potentialAce in playerHand {
                    if potentialAce.value == 11 {
                        potentialAce.value = 1
                        playerScore -= 10
                        break
                    }
                }
            }
        }
        for card in dealerHand {
            if card.hidden {
                break
            }
            dealerScore += card.value
            if dealerScore > 21 {
                for potentialAce in dealerHand {
                    if potentialAce.value == 11 {
                        potentialAce.value = 1
                        dealerScore -= 10
                        break
                    }
                }
            }
        }
        return (playerScore, dealerScore)
    }
    
    func checkGameState(playerScore: Int, dealerScore: Int, stand: Bool) -> (winner: Bool, push: Bool, finished: Bool) {
        if playerScore > 21 {
            return (false, false, true)
        }
        if dealerScore > 21 {
            return (true, false, true)
        }
        if stand {
            if dealerScore > 17 {
                if playerScore > dealerScore {
                    return (true, false, true)
                }
                if dealerScore > playerScore {
                    return (false, false, true)
                }
                if playerScore == dealerScore {
                    return (false, true, true)
                }
            }
            else {
                return (false, false, false)
            }
        }
        return (false , false, false)
    }
    
}

