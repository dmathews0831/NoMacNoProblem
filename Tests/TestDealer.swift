//
//  TestDealer.swift
//  
//
//  Created by Dylan Mathews on 3/18/26.
//

import XCTest
@testable import project

final class DeckTests: XCTestCase {
    func testDeckHas52Cards() {
        let deck = Deck()
        XCTAssertEqual(deck.cards.count, 52, "Deck should have 52 cards")
    }
    func testDeckHasUniqueCards() {
        let deck = Deck()
        let uniqueCards = Set(deck.cards.map { "\($0.suit)-\($0.faceValue)" })
        XCTAssertEqual(uniqueCards.count, 52, "All cards should be unique")
    }
}
