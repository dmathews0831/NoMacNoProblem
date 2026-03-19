//
//  projectTests.swift
//  projectTests
//
//  Created by Dylan Robert Mathews on 3/19/26.
//

import Testing
import XCTest
@testable import project

final class DeckTests: XCTestCase {
    func testDeckHas52Cards() {
        let deck = Deck()
        XCTAssertEqual(deck.cards.count, 52, "Deck should have 52 cards")
    }
    func testAllUnique() {
        let deck = Deck()
        let uniqueCards = Set(deck.cards.map { "\($0.suit)-\($0.faceValue)" })
        XCTAssertEqual(uniqueCards.count, 52, "Deck should have 52 unique cards")
    }
    func testDealerHoldsDeck() {
        let deck = Deck()
        let dealer = BlackjackDealer(deck: deck)
        
        XCTAssertEqual(dealer.deck.cards.count, 52)
    }
    func testDealerToStringNotEmpty() {
        let deck = Deck()
        let dealer = BlackjackDealer(deck: deck)
        
        let output = dealer.toString()
        
        XCTAssertFalse(output.isEmpty, "Dealer string output should not be empty")
    }
}
