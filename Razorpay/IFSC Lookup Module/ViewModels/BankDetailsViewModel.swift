//
//  BankDetailsViewModel.swift
//  Razorpay
//
//  Created by Hitesh Madaan on 16/06/25.
//

import Foundation
import Combine

// MARK: - Bank Details View Model
class BankDetailsViewModel: ObservableObject {
    @Published var bankDetails: BankDetails?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var ifscCode = ""
    
    private let bankService: BankServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // Search History Manager
    let searchHistoryManager = SearchHistoryManager()
    
    //Dependency Injection
    init(bankService: BankServiceProtocol = BankService()) {
        self.bankService = bankService
    }
    
    // MARK: - Public Methods
    func searchBankDetails() {
        guard !ifscCode.isEmpty else {
            errorMessage = "Please enter an IFSC code"
            return
        }
        
        guard isValidIFSCCode(ifscCode) else {
            errorMessage = "Please enter a valid IFSC code (11 characters)"
            return
        }
        
        isLoading = true
        errorMessage = nil
        bankDetails = nil
        
        bankService.fetchBankDetails(ifscCode: ifscCode.uppercased())
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] details in
                    guard let self = self else { return }
                    self.bankDetails = details
                    self.isLoading = false
                    
                    // Add to search history
                    self.searchHistoryManager.addSearch(
                        ifscCode: self.ifscCode.uppercased(),
                        bankDetails: details
                    )
                }
            )
            .store(in: &cancellables)
    }
    
    func loadFromHistory(_ historyItem: SearchHistoryItem) {
        ifscCode = historyItem.ifscCode
        bankDetails = historyItem.bankDetails
        errorMessage = nil
    }
    
    func clearResults() {
        bankDetails = nil
        errorMessage = nil
        ifscCode = ""
    }
    
    // MARK: - Private Methods
    private func isValidIFSCCode(_ code: String) -> Bool {
        return code.count == 11 && code.range(of: "^[A-Z]{4}0[A-Z0-9]{6}$", options: .regularExpression) != nil
    }
}
