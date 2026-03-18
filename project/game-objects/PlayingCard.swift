//
//  PlayingCard.swift
//  project
//
//  Created by Alexander Joseph Toskey on 2/18/26.
//

import Foundation

enum Suit: String {
    case clubs
    case diamonds
    case hearts
    case spades
}

enum FaceValue: String {
    case ace
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
    case jack
    case queen
    case king
}

enum Color: String {
    case red
    case black
}

class PlayingCard {
    let suit: Suit
    let value: Int
    let faceValue: FaceValue
    let color: Color
    
    init(suit: Suit, faceValue: FaceValue) {
        self.suit = suit
        self.faceValue = faceValue
        self.value = -1
        if (suit == .clubs || suit == .spades) {
            self.color = Color.black
        }
        else {
            self.color = Color.red
        }
    }
    
    func description() -> String {
        return "\(faceValue) of \(suit.rawValue.capitalized) (\(color.rawValue))"
    }
    
}

//let card = PlayingCard(suit: .hearts, faceValue: .ace)
//print(card.description())
