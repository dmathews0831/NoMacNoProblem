//
//  Player.swift
//  project
//
//  Created by Dylan Mathews on 2/18/26.
//
// Object-Oriented Programming - Model class with properties and methods for player state management
// Task 1: Check Balance - checkBalance() method
// Task 2: Claim Daily Bonus - claimDailyBonus() method
// Task 3: Place Bets - placeBet() method

// Object-Oriented Programming - Class encapsulates player state and behavior with properties and methods
class Player {
    var id: Int          // Property for player identification
    var balance: Int     // Property for tracking coin balance
    
    init(id: Int, balance: Int) {
        self.id = id
        self.balance = balance
    }
    
    // Task 1: Check Balance - Procedural utility to retrieve current balance
    // Procedural Programming - Simple utility function for reading state
    func checkBalance() -> Int {
        return self.balance
    }
    
    // Task 2: Claim Daily Bonus - Player claims daily bonus to increase balance
    // Procedural Programming - Utility function for bonus logic
    // Used by: MainMenuView button adds 1000 coins
    func claimDailyBonus(bonus: Int) {
        self.balance += bonus
    }
    
    // Task 3: Place Bets - Player deducts bet amount from balance
    // Procedural Programming - Utility function for bet management
    // Used by: BlackjackView and RouletteView
    func placeBet(amount: Int) {
        balance -= amount
    }
}
