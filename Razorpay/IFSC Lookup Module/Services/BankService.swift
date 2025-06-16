import Foundation
import Combine

// MARK: - Bank Service Protocol
protocol BankServiceProtocol {
    func fetchBankDetails(ifscCode: String) -> AnyPublisher<BankDetails, Error>
}

// MARK: - Bank Service Implementation
class BankService: BankServiceProtocol {
    private let session = URLSession.shared
    private let baseURL = "https://ifsc.razorpay.com/"
    
    func fetchBankDetails(ifscCode: String) -> AnyPublisher<BankDetails, Error> {
        guard let url = URL(string: "\(baseURL)\(ifscCode)") else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: BankDetails.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// MARK: - Network Error
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .networkError(let message):
            return message
        }
    }
}