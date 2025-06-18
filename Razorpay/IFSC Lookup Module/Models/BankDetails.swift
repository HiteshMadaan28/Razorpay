//
//  BankDetails.swift
//  Razorpay
//
//  Created by Hitesh Madaan on 16/06/25.
//

import Foundation

// MARK: - Bank Details Model
struct BankDetails: Codable {
    let micr: String?
    let branch: String
    let address: String
    let state: String
    let contact: String?
    let upi: Bool
    let rtgs: Bool
    let city: String
    let centre: String
    let district: String
    let neft: Bool
    let imps: Bool
    let swift: String?
    let iso3166: String
    let bank: String
    let bankcode: String
    let ifsc: String
    
    enum CodingKeys: String, CodingKey {
        case micr = "MICR"
        case branch = "BRANCH"
        case address = "ADDRESS"
        case state = "STATE"
        case contact = "CONTACT"
        case upi = "UPI"
        case rtgs = "RTGS"
        case city = "CITY"
        case centre = "CENTRE"
        case district = "DISTRICT"
        case neft = "NEFT"
        case imps = "IMPS"
        case swift = "SWIFT"
        case iso3166 = "ISO3166"
        case bank = "BANK"
        case bankcode = "BANKCODE"
        case ifsc = "IFSC"
    }
}
