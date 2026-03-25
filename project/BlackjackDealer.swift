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
    
    
}

