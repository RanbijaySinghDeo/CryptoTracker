//
//  DetailsViewModelTests.swift
//  CryptoTrackerTests
//
//  Created by Ranbijay SinghDeo on 26/11/24.
//

import Foundation
import XCTest
@testable import CryptoTracker

final class DetailsViewModelTests: XCTestCase {
    var viewModel: DetailsViewModel!
    var mockService: MockNetworkService!
    var mockCoin: Coin!

    override func setUp() {
        super.setUp()
        mockService = MockNetworkService()
        mockCoin = Coin(uuid: "test-uuid", symbol: "BTC", name: "Bitcoin", color: nil, iconURL: nil, marketCap: nil, price: nil, listedAt: nil, tier: nil, change: "10", rank: 1, sparkline: nil, lowVolume: nil, coinrankingURL: nil, the24HVolume: nil, btcPrice: nil)
        viewModel = DetailsViewModel(networkService: mockService, coin: mockCoin)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        mockCoin = nil
        super.tearDown()
    }

    // Test: Successful Graph Data Fetch
    func testFetchGraphData_Success() {
        // Mock data
        let mockHistory = [
            CoinHistory(price: "50000", timestamp: 1638480000),
            CoinHistory(price: "51000", timestamp: 1638566400)
        ]
        let mockResponse = CoinHistoryResponse(status: "200", data: CoinHistoryData(change: "5", history: mockHistory))
        mockService.mockResponse = mockResponse
        
        // Variable to check if the closure was called
        var didUpdateCalled = false
        
        // Set the closure to update the flag when data is fetched
        viewModel.didUpdateGraphData = {
            didUpdateCalled = true
            
            // Assert after data is updated
            XCTAssertNotNil(self.viewModel.graphData)
        }
    }

}

