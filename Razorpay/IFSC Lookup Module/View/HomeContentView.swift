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
        NavigationStack{
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
    
    // MARK: - Complete Bank Details View
    private func bankDetailsView(details: BankDetails) -> some View {
        VStack(spacing: 20) {
            // Bank Header
            VStack(spacing: 8) {
                Text(details.bank)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                
                Text(details.branch)
                    .font(.system(size: 15))
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
                    .fontWeight(.semibold)
            }
            .padding()
            .cornerRadius(12)
            
            // Primary Identifiers Section
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Primary Identifiers", icon: "creditcard.fill")
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    DetailCard(title: "IFSC Code", value: details.ifsc, icon: "number.circle.fill", color: .blue)
                    DetailCard(title: "Bank Code", value: details.bankcode, icon: "building.2.fill", color: .green)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // Location Information Section
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Location Information", icon: "location.fill")
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    DetailCard(title: "City", value: details.city, icon: "building.fill", color: .orange)
                    DetailCard(title: "State", value: details.state, icon: "map.fill", color: .purple)
                    DetailCard(title: "District", value: details.district, icon: "location.circle.fill", color: .red)
                    DetailCard(title: "Centre", value: details.centre, icon: "mappin.circle.fill", color: .teal)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // Additional Codes Section
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Additional Codes", icon: "barcode")
                
                VStack(spacing: 8) {
                    if let micr = details.micr, !micr.isEmpty {
                        InfoRow(label: "MICR Code", value: micr, icon: "barcode")
                    }
                    
                    if let swift = details.swift, !swift.isEmpty {
                        InfoRow(label: "SWIFT Code", value: swift, icon: "globe")
                    } else {
                        InfoRow(label: "SWIFT Code", value: "Not Available", icon: "globe")
                    }
                    
                    InfoRow(label: "ISO 3166 Code", value: details.iso3166, icon: "flag.fill")
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // Contact Information Section
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Contact Information", icon: "phone.fill")
                
                VStack(spacing: 8) {
                    if let contact = details.contact, !contact.isEmpty {
                        InfoRow(label: "Phone Number", value: contact, icon: "phone.circle.fill")
                    } else {
                        InfoRow(label: "Phone Number", value: "Not Available", icon: "phone.circle.fill")
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // Address Section
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Branch Address", icon: "location.fill")
                
                Text(details.address)
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // Banking Services Section
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Available Banking Services", icon: "creditcard.fill")
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ServiceCard(name: "UPI", isAvailable: details.upi, description: "Unified Payments Interface")
                    ServiceCard(name: "RTGS", isAvailable: details.rtgs, description: "Real Time Gross Settlement")
                    ServiceCard(name: "NEFT", isAvailable: details.neft, description: "National Electronic Funds Transfer")
                    ServiceCard(name: "IMPS", isAvailable: details.imps, description: "Immediate Payment Service")
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // Complete Information Summary
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Complete Information Summary", icon: "list.bullet.clipboard.fill")
                
                VStack(spacing: 6) {
                    InfoRow(label: "Bank Name", value: details.bank, icon: "building.columns.fill")
                    InfoRow(label: "Branch Name", value: details.branch, icon: "building.fill")
                    InfoRow(label: "IFSC Code", value: details.ifsc, icon: "number.circle.fill")
                    InfoRow(label: "Bank Code", value: details.bankcode, icon: "building.2.fill")
                    InfoRow(label: "City", value: details.city, icon: "building.fill")
                    InfoRow(label: "State", value: details.state, icon: "map.fill")
                    InfoRow(label: "District", value: details.district, icon: "location.circle.fill")
                    InfoRow(label: "Centre", value: details.centre, icon: "mappin.circle.fill")
                    InfoRow(label: "ISO 3166", value: details.iso3166, icon: "flag.fill")
                    
                    if let micr = details.micr, !micr.isEmpty {
                        InfoRow(label: "MICR Code", value: micr, icon: "barcode")
                    }
                    
                    if let contact = details.contact, !contact.isEmpty {
                        InfoRow(label: "Contact", value: contact, icon: "phone.circle.fill")
                    }
                    
                    if let swift = details.swift, !swift.isEmpty {
                        InfoRow(label: "SWIFT Code", value: swift, icon: "globe")
                    }
                    
                    InfoRow(label: "UPI Available", value: details.upi ? "Yes" : "No", icon: "checkmark.circle.fill")
                    InfoRow(label: "RTGS Available", value: details.rtgs ? "Yes" : "No", icon: "checkmark.circle.fill")
                    InfoRow(label: "NEFT Available", value: details.neft ? "Yes" : "No", icon: "checkmark.circle.fill")
                    InfoRow(label: "IMPS Available", value: details.imps ? "Yes" : "No", icon: "checkmark.circle.fill")
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
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
