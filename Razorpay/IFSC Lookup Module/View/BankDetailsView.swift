//
//  BankDetailsView.swift
//  Razorpay
//
//  Created by Hitesh Madaan on 16/06/25.
//

import SwiftUI

struct BankDetailsView: View {
    let bankDetails: BankDetails
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Bank Header
                VStack(spacing: 8) {
                    Text(bankDetails.bank)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                    
                    Text(bankDetails.branch)
                        .font(.title2)
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.center)
                        .fontWeight(.semibold)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                
                // Primary Identifiers Section
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Primary Identifiers", icon: "creditcard.fill")
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        DetailCard(title: "IFSC Code", value: bankDetails.ifsc, icon: "number.circle.fill", color: .blue)
                        DetailCard(title: "Bank Code", value: bankDetails.bankcode, icon: "building.2.fill", color: .green)
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
                        DetailCard(title: "City", value: bankDetails.city, icon: "building.fill", color: .orange)
                        DetailCard(title: "State", value: bankDetails.state, icon: "map.fill", color: .purple)
                        DetailCard(title: "District", value: bankDetails.district, icon: "location.circle.fill", color: .red)
                        DetailCard(title: "Centre", value: bankDetails.centre, icon: "mappin.circle.fill", color: .teal)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Additional Codes Section
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Additional Codes", icon: "barcode")
                    
                    VStack(spacing: 8) {
                        if let micr = bankDetails.micr, !micr.isEmpty {
                            InfoRow(label: "MICR Code", value: micr, icon: "barcode")
                        }
                        
                        if let swift = bankDetails.swift, !swift.isEmpty {
                            InfoRow(label: "SWIFT Code", value: swift, icon: "globe")
                        } else {
                            InfoRow(label: "SWIFT Code", value: "Not Available", icon: "globe")
                        }
                        
                        InfoRow(label: "ISO 3166 Code", value: bankDetails.iso3166, icon: "flag.fill")
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Contact Information Section
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Contact Information", icon: "phone.fill")
                    
                    VStack(spacing: 8) {
                        if let contact = bankDetails.contact, !contact.isEmpty {
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
                    
                    Text(bankDetails.address)
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
                        ServiceCard(name: "UPI", isAvailable: bankDetails.upi, description: "Unified Payments Interface")
                        ServiceCard(name: "RTGS", isAvailable: bankDetails.rtgs, description: "Real Time Gross Settlement")
                        ServiceCard(name: "NEFT", isAvailable: bankDetails.neft, description: "National Electronic Funds Transfer")
                        ServiceCard(name: "IMPS", isAvailable: bankDetails.imps, description: "Immediate Payment Service")
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Complete Information Summary
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Complete Information Summary", icon: "list.bullet.clipboard.fill")
                    
                    VStack(spacing: 6) {
                        InfoRow(label: "Bank Name", value: bankDetails.bank, icon: "building.columns.fill")
                        InfoRow(label: "Branch Name", value: bankDetails.branch, icon: "building.fill")
                        InfoRow(label: "IFSC Code", value: bankDetails.ifsc, icon: "number.circle.fill")
                        InfoRow(label: "Bank Code", value: bankDetails.bankcode, icon: "building.2.fill")
                        InfoRow(label: "City", value: bankDetails.city, icon: "building.fill")
                        InfoRow(label: "State", value: bankDetails.state, icon: "map.fill")
                        InfoRow(label: "District", value: bankDetails.district, icon: "location.circle.fill")
                        InfoRow(label: "Centre", value: bankDetails.centre, icon: "mappin.circle.fill")
                        InfoRow(label: "ISO 3166", value: bankDetails.iso3166, icon: "flag.fill")
                        
                        if let micr = bankDetails.micr, !micr.isEmpty {
                            InfoRow(label: "MICR Code", value: micr, icon: "barcode")
                        }
                        
                        if let contact = bankDetails.contact, !contact.isEmpty {
                            InfoRow(label: "Contact", value: contact, icon: "phone.circle.fill")
                        }
                        
                        if let swift = bankDetails.swift, !swift.isEmpty {
                            InfoRow(label: "SWIFT Code", value: swift, icon: "globe")
                        }
                        
                        InfoRow(label: "UPI Available", value: bankDetails.upi ? "Yes" : "No", icon: "checkmark.circle.fill")
                        InfoRow(label: "RTGS Available", value: bankDetails.rtgs ? "Yes" : "No", icon: "checkmark.circle.fill")
                        InfoRow(label: "NEFT Available", value: bankDetails.neft ? "Yes" : "No", icon: "checkmark.circle.fill")
                        InfoRow(label: "IMPS Available", value: bankDetails.imps ? "Yes" : "No", icon: "checkmark.circle.fill")
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Bank Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
struct BankDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BankDetailsView(bankDetails: BankDetails(
                micr: "110196002",
                branch: "Delhi Nagrik Sehkari Bank IMPS",
                address: "720, NEAR GHANTAGHAR, SUBZI MANDI, DELHI - 110007",
                state: "MAHARASHTRA",
                contact: "+919560344685",
                upi: true,
                rtgs: true,
                city: "MUMBAI",
                centre: "DELHI",
                district: "DELHI",
                neft: true,
                imps: true,
                swift: "",
                iso3166: "IN-MH",
                bank: "Delhi Nagrik Sehkari Bank",
                bankcode: "DENS",
                ifsc: "YESB0DNB002"
            ))
        }
    }
}
