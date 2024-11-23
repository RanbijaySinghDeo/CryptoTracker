//
//  Constants.swift
//  CryptoTracker
//
//  Created by Ranbijay SinghDeo on 22/11/24.
//

import Foundation


struct Constants {
    static let cryptoCellReuseIdentifier = "CryptoCellIdentifier"
    static let dashboardTitle = "Dashboard"
    static let toastPadding: CGFloat = 16.0
    static let toastDuration: TimeInterval = 2.0
    struct Labels {
            static let allTimeHigh = "All time high"
            static let nameOfCoin = "Name of coin"
            static let symbolOfCoin = "Symbol of coin"
            static let totalSupply = "Total supply"
            static let marketCap = "Market cap"
            static let rank = "Rank"
            static let circulatingSupply = "Circulating supply"
            static let about = "About"
            static let high = "High: "
            static let low = "Low: "
        }
        
        struct Placeholders {
            static let notAvailable = "N/A"
        }
        
        struct Graph {
            static let defaultTimePeriod = "1h"
            static let timePeriods = ["1h", "24h", "7d", "30d", "1y"]
        }
        
        struct Navigation {
            static let backButtonTitle = ""
        }
}
