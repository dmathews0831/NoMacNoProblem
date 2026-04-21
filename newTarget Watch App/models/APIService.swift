//
//  APIService.swift
//  project
//
//  Created by CS3714 on 4/21/26.
//

import Foundation

class APIService {
    
    func fetchRandomNumber() async throws -> Int {
        
        // Create the URL
        let url = URL(string: "https://www.random.org/integers/?num=1&min=-1&max=36&col=1&base=10&format=plain&rnd=new")
        
        // Make the request
        let (data, _) = try await URLSession.shared.data(from: url!)
        
        // Convert to string
        guard let string = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        // Trim whitespace/newlines and convert to Int
        guard let number = Int(string.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            throw URLError(.cannotParseResponse)
        }
        
        // Return the random number
        return number
    }
    
}
