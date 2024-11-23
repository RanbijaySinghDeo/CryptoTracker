//
//  MockNetworkManager.swift
//  CryptoTrackerTests
//
//  Created by Ranbijay SinghDeo on 22/11/24.
//

import Foundation
@testable import CryptoTracker

class MockNetworkService: NetworkService {
    func fetchCoinHistory(uuid: String, timePeriod: String, completion: @escaping (Result<CryptoTracker.CoinHistoryResponse, any Error>) -> Void) {
        
    }
    
    func fetchCoinDetails(uuid: String, completion: @escaping (Result<CryptoTracker.DetailsCryptoCoinDetailsResponse, any Error>) -> Void) {
        
    }
    
    var coinsToReturn: [Coin] = []
    var errorToReturn: Error?
    
    func fetchCryptocurrencies(page: Int, completion: @escaping (Result<[Coin], Error>) -> Void) {
        if let error = errorToReturn {
            completion(.failure(error))
        } else {
            completion(.success(coinsToReturn))
        }
    }
}
