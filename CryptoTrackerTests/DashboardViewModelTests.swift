//
//  DashboardViewModelTests.swift
//  CryptoTrackerTests
//
//  Created by Ranbijay SinghDeo on 22/11/24.
//

import Foundation
import XCTest
@testable import CryptoTracker

class MockDelegate: CryptoViewModelDelegate {
    let callback: () -> Void
    
    init(callback: @escaping () -> Void) {
        self.callback = callback
    }
    
    func didUpdateCoins() {
        callback()
    }
}

class DashboardViewModelTests: XCTestCase {
    var viewModel: DashboardViewModel!
    var mockService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockService = MockNetworkService()
        viewModel = DashboardViewModel(networkService: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testViewModelInitialization() {
        XCTAssertTrue(viewModel.allCoins.isEmpty)
        XCTAssertTrue(viewModel.favoriteCoins.isEmpty)
        XCTAssertTrue(viewModel.filteredCoins.isEmpty)
        XCTAssertEqual(viewModel.currentPage, 0)
    }
    
    func testFilterCoins() {
        let mockService = MockNetworkService()
        let viewModel = DashboardViewModel(networkService: mockService)
        
        let mockCoins = [
            Coin(uuid: "1", name: "Bitcoin", price: "1000", rank: 1),
            Coin(uuid: "2", name: "Ethereum", price: "500", rank: 2),
            Coin(uuid: "3", name: "XRP", price: "1", rank: 200)
        ]
        viewModel.allCoins = mockCoins
        
        // Case 1: Filter top 100 coins
        viewModel.filterCoins(by: 1)
        XCTAssertEqual(viewModel.filteredCoins.count, 2)
        
        // Case 2: Sort by price (descending)
        viewModel.filterCoins(by: 2)
        XCTAssertEqual(viewModel.filteredCoins.first?.name, "Bitcoin")
        
        // Case 3: Favorite coins
        viewModel.addFavorite(mockCoins[0])
        viewModel.filterCoins(by: 3)
        XCTAssertEqual(viewModel.filteredCoins.count, 1)
        XCTAssertEqual(viewModel.filteredCoins.first?.name, "Bitcoin")
    }
    
    func testToggleFavorite() {
        let mockService = MockNetworkService()
        let viewModel = DashboardViewModel(networkService: mockService)
        
        let mockCoin = Coin(uuid: "1", name: "Bitcoin", price: "1000", rank: 1)
        
        // Add to favorites
        let isFavorite = viewModel.toggleFavorite(for: mockCoin)
        XCTAssertTrue(isFavorite)
        XCTAssertEqual(viewModel.favoriteCoins.count, 1)
        
        // Remove from favorites
        let isRemoved = viewModel.toggleFavorite(for: mockCoin)
        XCTAssertFalse(isRemoved)
        XCTAssertTrue(viewModel.favoriteCoins.isEmpty)
    }
}

