//
//  APIManager.swift
//  ToDoWork
//
//  Created by Drolllted on 29.05.2025.
//

import Foundation

final class APIManager {
    
    static let shared = APIManager()
    
    func setupJSON(completion: @escaping (Result<WelcomeJSON, APIErrors>) -> Void) {
        let url = "https://dummyjson.com/todos"
        guard let urlString = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlString) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(.error))
                return
            }
            
            guard response is HTTPURLResponse else {
                completion(.failure(.responceNot200))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let jsonDecoding = JSONDecoder()
                let json = try jsonDecoding.decode(WelcomeJSON.self, from: data)
                print(json)
                completion(.success(json))
            } catch {
                print(error.localizedDescription)
                completion(.failure(.noData))
            }
        }
        task.resume()
    }
}
