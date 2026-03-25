//
//  PlayingCard.swift
//  project
//
//  Created by Alexander Joseph Toskey on 2/18/26.
//

import Foundation

enum Suit: String {
    case clubs = "\u{2663}"
    case diamonds = "\u{2666}"
    case hearts = "\u{2665}"
    case spades = "\u{2660}"
}

enum FaceValue: String {
    case ace = "A"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case ten = "10"
    case jack = "J"
    case queen = "Q"
    case king = "K"
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
        return faceValue.rawValue + suit.rawValue
    }
    
}

//let card = PlayingCard(suit: .hearts, faceValue: .ace)
//print(card.description())
