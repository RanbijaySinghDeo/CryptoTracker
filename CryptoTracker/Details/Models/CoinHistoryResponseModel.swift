//
//  CoinHistoryResponseModel.swift
//  CryptoTracker
//
//  Created by Ranbijay SinghDeo on 23/11/24.
//

import Foundation

struct CoinHistoryResponse: Codable {
    let status: String
    let data: CoinHistoryData
}

struct CoinHistoryData: Codable {
    let change: String
    let history: [CoinHistory]
}

struct CoinHistory: Codable {
    let price: String
    let timestamp: Int
}
