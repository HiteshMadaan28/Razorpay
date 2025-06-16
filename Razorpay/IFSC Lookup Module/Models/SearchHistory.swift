//
//  SearchHistory.swift
//  Razorpay
//
//  Created by Hitesh Madaan on 16/06/25.
//

import Foundation
import Combine
internal import SwiftUICore

// MARK: - Search History Item Model
struct SearchHistoryItem: Codable, Identifiable {
    let id = UUID()
    let ifscCode: String
    let bankDetails: BankDetails
    let searchDate: Date
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: searchDate)
    }
}

// MARK: - Search History Manager
class SearchHistoryManager: ObservableObject {
    @Published var searchHistory: [SearchHistoryItem] = []
    private let userDefaults = UserDefaults.standard
    private let historyKey = "IFSCSearchHistory"
    
    init() {
        loadHistory()
    }
    
    func addSearch(ifscCode: String, bankDetails: BankDetails) {
        // Check if this IFSC code already exists in history
        if let existingIndex = searchHistory.firstIndex(where: { $0.ifscCode == ifscCode }) {
            // Remove the existing entry
            searchHistory.remove(at: existingIndex)
        }
        
        // Add new search at the beginning
        let newItem = SearchHistoryItem(
            ifscCode: ifscCode,
            bankDetails: bankDetails,
            searchDate: Date()
        )
        searchHistory.insert(newItem, at: 0)
        
        // Keep only last 50 searches
        if searchHistory.count > 50 {
            searchHistory = Array(searchHistory.prefix(50))
        }
        
        saveHistory()
    }
    
    func removeSearch(at indexSet: IndexSet) {
        searchHistory.remove(atOffsets: indexSet)
        saveHistory()
    }
    
    func clearAllHistory() {
        searchHistory.removeAll()
        saveHistory()
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(searchHistory) {
            userDefaults.set(encoded, forKey: historyKey)
        }
    }
    
    private func loadHistory() {
        if let data = userDefaults.data(forKey: historyKey),
           let decoded = try? JSONDecoder().decode([SearchHistoryItem].self, from: data) {
            searchHistory = decoded
        }
    }
}
