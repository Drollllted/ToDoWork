//
//  APIErrors.swift
//  ToDoWork
//
//  Created by Drolllted on 29.05.2025.
//

import Foundation

enum APIErrors: String, Error {
    
    case noData
    case responceNot200
    case error
    case catchError
    
    var string: String {
        switch self{
            
        case .noData:
            "Not current data in JSON"
        case .responceNot200:
            "Invalid response"
        case .error:
            "Error: \(APIErrors.error.localizedDescription)"
        case .catchError:
            "Error with do, what's wrong?"
        }
    }
    
}
