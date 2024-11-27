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
    var mockError: Error?
    
    func fetchCryptocurrencies(page: Int, completion: @escaping (Result<[Coin], Error>) -> Void) {
        if let result = fetchCoinsResult {
            completion(result)
        }
    }
    
    func fetchCoinHistory(uuid: String, timePeriod: String, completion: @escaping (Result<CoinHistoryResponse, Error>) -> Void) {
        if shouldReturnError {
            if let error = mockError {
                completion(.failure(error))
            } else {
                completion(.failure(NSError(domain: "NetworkError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Default Mock Error"])))
            }
        } else if let response = mockResponse {
            completion(.success(response))
        } else {
            completion(.failure(NSError(domain: "NetworkError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No Mock Response"])))
        }
    }
    
    func fetchCoinDetails(uuid: String, completion: @escaping (Result<DetailsCryptoCoinDetailsResponse, Error>) -> Void) {}
}

