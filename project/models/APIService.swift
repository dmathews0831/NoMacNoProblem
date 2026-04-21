//
//  APIService.swift
//  project
//
//  Created by Alexander Joseph Toskey on 4/19/26.
//
//  Description: This file contains the API service model for fetching a random number from Random.org.

import Foundation

class APIService {
    
    // Function to fetch a random number
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
    
    // Function to fetch a random number with a timeout constraint
    // NON-FUNCTIONAL REQUIREMENT: Fetching a random number should take less than 1 second in online mode
    func fetchWithTimeout(seconds: Double) async throws -> Int? {
        await withTaskGroup(of: Int?.self) { group in
            
            // Task 1: API call
            group.addTask {
                return try? await self.fetchRandomNumber()
            }
            
            // Task 2: Timeout
            group.addTask {
                try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
                return nil
            }
            
            // Return whichever finishes first
            let result = await group.next()!
            group.cancelAll()
            
            return result
        }
    }
}
