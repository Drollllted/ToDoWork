//
//  DateFormatterHelper.swift
//  ToDoWork
//
//  Created by Drolllted on 30.05.2025.
//

import Foundation

struct DateFormatterHelper {
    static let shared = DateFormatterHelper()
    
    private let formatter = DateFormatter()
    
    func formattedDate(from date: Date) -> String {
        formatter.dateStyle = .long
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
}
