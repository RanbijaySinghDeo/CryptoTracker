import Foundation

// MARK: - DetailsCryptoCoinDetailsResponse
public struct DetailsCryptoCoinDetailsResponse: Codable {
    public var status: String?
    public var data: DetailsCryptoData?
}

// MARK: - DetailsCryptoData
public struct DetailsCryptoData: Codable {
    public var coin: DetailsCryptoCoin?
}

// MARK: - DetailsCryptoCoin
public struct DetailsCryptoCoin: Codable {
    public var uuid: String?
    public var symbol: String?
    public var name: String?
    public var description: String?
    public var color: String?
    public var iconUrl: String?
    public var websiteUrl: String?
    public var links: [DetailsCryptoLink]?
    public var supply: DetailsCryptoSupply?
    public var price: String?
    public var marketCap: String?
    public var change: String?
    public var rank: Int?
    public var sparkline: [String?]?
    public var allTimeHigh: DetailsCryptoAllTimeHigh?

    public enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, description, color
        case iconUrl
        case websiteUrl
        case links, supply, price, marketCap, change, rank, sparkline, allTimeHigh
    }
}

// MARK: - DetailsCryptoLink
public struct DetailsCryptoLink: Codable {
    public var name: String?
    public var url: String?
    public var type: String?
}

// MARK: - DetailsCryptoSupply
public struct DetailsCryptoSupply: Codable {
    public var confirmed: Bool?
    public var max: String?
    public var total: String?
    public var circulating: String?
}

// MARK: - DetailsCryptoAllTimeHigh
public struct DetailsCryptoAllTimeHigh: Codable {
    public var price: String?
    public var timestamp: Int?
}
