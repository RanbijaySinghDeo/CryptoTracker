//
//  MockNetworkManager.swift
//  CryptoTrackerTests
//
//  Created by Ranbijay SinghDeo on 22/11/24.
//

import Foundation
@testable import CryptoTracker

class MockNetworkService: NetworkService {
    var fetchCoinsResult: Result<[Coin], Error>?
    var shouldReturnError = false
    var mockResponse: CoinHistoryResponse?
    
    func fetchCryptocurrencies(page: Int, completion: @escaping (Result<[Coin], Error>) -> Void) {
        if let result = fetchCoinsResult {
            completion(result)
        }
    }
    func fetchCoinHistory(uuid: String, timePeriod: String, completion: @escaping (Result<CoinHistoryResponse, Error>) -> Void) {
        if shouldReturnError {
            let error = NSError(domain: "NetworkError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock Error"])
            completion(.failure(error))
        } else if let response = mockResponse {
            completion(.success(response))
        }
    }
    func fetchCoinDetails(uuid: String, completion: @escaping (Result<DetailsCryptoCoinDetailsResponse, Error>) -> Void) {}
}

