//
//  HomeContentView.swift
//  Razorpay
//
//  Created by Hitesh Madaan on 16/06/25.
//

import SwiftUI

struct HomeContentView: View {
    @StateObject private var viewModel = BankDetailsViewModel()
    @State private var showingHistory = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    headerView
                    
                    // Search Section
                    searchSection
                    
                    // Results Section
                    if viewModel.isLoading {
                        loadingView
                    } else if let errorMessage = viewModel.errorMessage {
                        errorView(message: errorMessage)
                    } else if let bankDetails = viewModel.bankDetails {
                        NavigationLink(destination: BankDetailsView(bankDetails: bankDetails)) {
                            bankDetailsPreview(details: bankDetails)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("IFSC Lookup")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingHistory = true
                    }) {
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                            Text("History")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingHistory) {
                SearchHistoryView(viewModel: viewModel)
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 8) {
            Image(systemName: "building.columns.fill")
                .font(.system(size: 50))
                .foregroundColor(.blue)
            
            Text("Bank Details Finder")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Enter IFSC code to get complete bank information")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical)
    }
    
    // MARK: - Search Section
    private var searchSection: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("IFSC Code")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                TextField("Enter IFSC Code (e.g., YESB0DNB002)", text: $viewModel.ifscCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.allCharacters)
                    .disableAutocorrection(true)
                    .onSubmit {
                        viewModel.searchBankDetails()
                    }
            }
            
            HStack(spacing: 12) {
                Button(action: {
                    viewModel.searchBankDetails()
                }) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(viewModel.ifscCode.isEmpty || viewModel.isLoading)
                
                Button(action: {
                    viewModel.clearResults()
                }) {
                    HStack {
                        Image(systemName: "xmark.circle")
                        Text("Clear")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.primary)
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Fetching bank details...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    // MARK: - Error View
    private func errorView(message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.red)
            
            Text("Error")
                .font(.headline)
                .foregroundColor(.red)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(12)
    }
    
    // MARK: - Bank Details Preview
    private func bankDetailsPreview(details: BankDetails) -> some View {
        VStack(spacing: 16) {
            // Bank Header
            VStack(spacing: 8) {
                Text(details.bank)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                
                Text(details.branch)
                    .font(.headline)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
                    .fontWeight(.semibold)
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
            
            // Quick Info
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("IFSC Code")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(details.ifsc)
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("City")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(details.city)
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("State")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(details.state)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Bank Code")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(details.bankcode)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            // Tap to view more indicator
            HStack {
                Text("Tap to view complete details")
                    .font(.caption)
                    .foregroundColor(.blue)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}

// MARK: - Section Header Component
struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.title2)
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
        }
    }
}

// MARK: - Enhanced Detail Card Component
struct DetailCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .fontWeight(.medium)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}

// MARK: - Info Row Component
struct InfoRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Enhanced Service Card Component
struct ServiceCard: View {
    let name: String
    let isAvailable: Bool
    let description: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: isAvailable ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(isAvailable ? .green : .red)
                    .font(.title2)
                
                Text(name)
                    .font(.headline)
                    .fontWeight(.bold)
            }
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Text(isAvailable ? "Available" : "Not Available")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(isAvailable ? .green : .red)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(isAvailable ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isAvailable ? Color.green.opacity(0.3) : Color.red.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    HomeContentView()
}
