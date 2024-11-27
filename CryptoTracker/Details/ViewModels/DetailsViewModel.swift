//
//  DetailsViewModel.swift
//  CryptoTracker
//
//  Created by Ranbijay SinghDeo on 23/11/24.
//

import Foundation
import UIKit

struct GraphPoint {
    let price: Double
    let timestamp: Int
}

class DetailsViewModel {
    private let networkService: NetworkService
    let coin: Coin
    
    var didUpdateGraphData: (() -> Void)?
    var didEncounterError: ((String) -> Void)?
    private(set) var graphData: [GraphPoint] = []
    private(set) var isProfit: Bool = false
    
    init(networkService: NetworkService = NetworkManager.shared, coin: Coin) {
        self.networkService = networkService
        self.coin = coin
    }
    
    func fetchGraphData(for timePeriod: String) {
        networkService.fetchCoinHistory(uuid: coin.uuid ?? "", timePeriod: timePeriod) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.graphData = self.mapGraphData(response: response)
                    self.isProfit = Double(response.data.change) ?? 0 > 0
                    self.didUpdateGraphData?()
                case .failure(let error):
                    self.didEncounterError?(error.localizedDescription)
                }
            }
        }
    }
    
    func graphPoints() -> [Double] {
        return graphData.map { $0.price }
    }

    func graphColor() -> UIColor {
        return isProfit ? .green : .red
    }

    private func mapGraphData(response: CoinHistoryResponse) -> [GraphPoint] {
        return response.data.history.compactMap { historyItem in
            guard let price = Double(historyItem.price) else { return nil }
            return GraphPoint(price: price, timestamp: historyItem.timestamp)
        }
    }
    
}
