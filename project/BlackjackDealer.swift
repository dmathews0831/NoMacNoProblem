//
//  BlackjackDealer.swift
//  project
//
//  Created by Alexander Joseph Toskey on 2/23/26.
//
import PlayingCard

struct Deck {
    let suits: [Suit] = [.clubs, .spades, .hearts, .diamonds]
        let values: [FaceValue] = [.ace, .two, .three, .four, .five, .six, .seven, .eight, .nine, .ten, .jack, .queen, .king]
    let cards: [PlayingCard] = []

    init() {
        for suit in suits {
            for value in values {
                cards.append(PlayingCard(suit: suit, faceValue: value))
            }
        }
    }
}

class BlackjackDealer {
    
    let deck: Deck
    
    init(deck: Deck) {
        self.deck = deck
    }
    
    func toString() -> String {
        return "\(deck.cards)"
    }
    
}
let deck = Deck(cards: <#T##PlayingCard#>)
let dealer = BlackjackDealer(deck: <#T##Deck#>)
