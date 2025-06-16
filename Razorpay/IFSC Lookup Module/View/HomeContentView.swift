//
//  HomeContentView.swift
//  Razorpay
//
//  Created by Hitesh Madaan on 16/06/25.
//

import SwiftUI

struct HomeContentView: View {
    @StateObject private var viewModel = BankDetailsViewModel()
    
    var body: some View {
        NavigationView {
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
                        bankDetailsView(details: bankDetails)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("IFSC Lookup")
            .navigationBarTitleDisplayMode(.large)
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
            
            Text("Enter IFSC code to get bank information")
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
                
                TextField("Enter IFSC Code (e.g., SBIN0000001)", text: $viewModel.ifscCode)
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
    
    // MARK: - Bank Details View
    private func bankDetailsView(details: BankDetails) -> some View {
        VStack(spacing: 16) {
            // Bank Header
            VStack(spacing: 8) {
                Text(details.bank)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(details.branch)
                    .font(.headline)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 8)
            
            // Details Grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                DetailCard(title: "IFSC Code", value: details.ifsc, icon: "number.circle.fill")
                DetailCard(title: "Bank Code", value: details.bankcode, icon: "building.2.fill")
                DetailCard(title: "City", value: details.city, icon: "location.fill")
                DetailCard(title: "State", value: details.state, icon: "map.fill")
                DetailCard(title: "District", value: details.district, icon: "location.circle.fill")
                
                if let micr = details.micr, !micr.isEmpty {
                    DetailCard(title: "MICR Code", value: micr, icon: "barcode")
                }
            }
            
            // Address Section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                    Text("Address")
                        .font(.headline)
                }
                
                Text(details.address)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            // Services Section
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "creditcard.fill")
                        .foregroundColor(.green)
                    Text("Available Services")
                        .font(.headline)
                }
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 8) {
                    ServiceBadge(name: "UPI", isAvailable: details.upi)
                    ServiceBadge(name: "RTGS", isAvailable: details.rtgs)
                    ServiceBadge(name: "NEFT", isAvailable: details.neft)
                    ServiceBadge(name: "IMPS", isAvailable: details.imps)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

// MARK: - Detail Card Component
struct DetailCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// MARK: - Service Badge Component
struct ServiceBadge: View {
    let name: String
    let isAvailable: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: isAvailable ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(isAvailable ? .green : .red)
                .font(.caption)
            
            Text(name)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(isAvailable ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
        .cornerRadius(6)
    }
}

#Preview {
    HomeContentView()
}
