//
//  Untitled.swift
//  project
//
//  Created by Dylan Mathews on 2/18/26.
//

class Player {
    var id: Int
    var balance: Int
    
    init(id: Int, balance: Int) {
        self.id = id
        self.balance = balance
    }
    
    func checkBalance() -> Int {
        return self.balance
    }
    
    func claimDailyBonus(bonus: Int) {
        self.balance += bonus
    }
    
    func login() {
        // fill
    }
    
    func logout() {
        // fill
    }
    
    func signup() {
        // fill
    }
    
    func createGame(game: String) {
        // fill, check param
    }
    
    func playGame() {
        // fill, check param
    }
    
    func placeBet(amount: Int) {
        balance -= amount
    }
}
