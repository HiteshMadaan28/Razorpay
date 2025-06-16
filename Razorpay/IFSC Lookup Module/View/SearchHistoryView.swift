//
//  SearchHistoryView.swift
//  Razorpay
//
//  Created by Hitesh Madaan on 16/06/25.
//

import SwiftUI

struct SearchHistoryView: View {
    @ObservedObject var viewModel: BankDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.searchHistoryManager.searchHistory.isEmpty {
                    emptyHistoryView
                } else {
                    historyListView
                }
            }
            .navigationTitle("Search History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                if !viewModel.searchHistoryManager.searchHistory.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Clear All") {
                            viewModel.searchHistoryManager.clearAllHistory()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
    }
    
    // MARK: - Empty History View
    private var emptyHistoryView: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Search History")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Your previous IFSC code searches will appear here")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - History List View
    private var historyListView: some View {
        List {
            ForEach(viewModel.searchHistoryManager.searchHistory) { historyItem in
                NavigationLink(destination: BankDetailsView(bankDetails: historyItem.bankDetails)) {
                    HistoryRowView(historyItem: historyItem)
                }
            }
            .onDelete(perform: deleteHistoryItems)
        }
        .listStyle(PlainListStyle())
    }
    
    private func deleteHistoryItems(offsets: IndexSet) {
        viewModel.searchHistoryManager.removeSearch(at: offsets)
    }
}

// MARK: - History Row View
struct HistoryRowView: View {
    let historyItem: SearchHistoryItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(historyItem.bankDetails.bank)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text(historyItem.bankDetails.branch)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(historyItem.ifscCode)
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(6)
                    
                    Text(historyItem.formattedDate)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                Label(historyItem.bankDetails.city, systemImage: "building.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Label(historyItem.bankDetails.state, systemImage: "map.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview
struct SearchHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchHistoryView(viewModel: BankDetailsViewModel())
    }
}
