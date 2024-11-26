//
//  CryptoInquiryModel.swift
//  CryptoTracker
//
//  Created by Ranbijay SinghDeo on 22/11/24.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let crypto = try? JSONDecoder().decode(Crypto.self, from: jsonData)

import Foundation

// MARK: - Crypto
struct Crypto: Codable {
    var status: String?
    var data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    var stats: Stats?
    var coins: [Coin]?
}

// MARK: - Coin
struct Coin: Codable, Equatable {
    var uuid, symbol, name, color: String?
    var iconURL: String?
    var marketCap, price: String?
    var listedAt, tier: Int?
    var change: String?
    var rank: Int?
    var sparkline: [String?]?
    var lowVolume: Bool?
    var coinrankingURL: String?
    var the24HVolume, btcPrice: String?
    
    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, color
        case iconURL = "iconUrl"
        case marketCap, price, listedAt, tier, change, rank, sparkline, lowVolume
        case coinrankingURL
        case the24HVolume
        case btcPrice
    }
    static func == (lhs: Coin, rhs: Coin) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

// MARK: - Stats
struct Stats: Codable {
    var total, totalCoins, totalMarkets, totalExchanges: Int?
    var totalMarketCap, total24HVolume: String?

    enum CodingKeys: String, CodingKey {
        case total, totalCoins, totalMarkets, totalExchanges, totalMarketCap
        case total24HVolume
    }
}


