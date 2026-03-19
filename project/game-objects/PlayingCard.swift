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
        if (faceValue == .king || faceValue == .queen || faceValue == .jack || faceValue == .ten) {
            self.value = 10
        }
        else if (faceValue == .nine) {
            self.value = 9
        }
        else if (faceValue == .eight) {
            self.value = 8
        }
        else if (faceValue == .seven) {
            self.value = 7
        }
        else if (faceValue == .six) {
            self.value = 6
        }
        else if (faceValue == .five) {
            self.value = 5
        }
        else if (faceValue == .four) {
            self.value = 4
        }
        else if (faceValue == .three) {
            self.value = 3
        }
        else if (faceValue == .two) {
            self.value = 2
        }
        else {
            self.value = 11
        }
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
