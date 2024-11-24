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
    
    func fetchCryptocurrencies(page: Int, completion: @escaping (Result<[Coin], Error>) -> Void) {
        if let result = fetchCoinsResult {
            completion(result)
        }
    }
    
    func fetchCoinHistory(uuid: String, timePeriod: String, completion: @escaping (Result<CoinHistoryResponse, Error>) -> Void) {}
    func fetchCoinDetails(uuid: String, completion: @escaping (Result<DetailsCryptoCoinDetailsResponse, Error>) -> Void) {}
}

