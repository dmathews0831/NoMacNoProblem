//
//  PokerChip.swift
//  project
//
//  Created by Alexander Joseph Toskey on 2/23/26.
//



class PokerChip {
    
    let value: Int;
    let color: String;
    let radius: Int = 20;
    
    init(value: Int, color: String) {
        self.value = value;
        self.color = color;
    }
    
    func description() -> String {
        return "Value: \(self.value), Color: \(self.color)";
    }
    
    
    
    

    
}
                    
                    
