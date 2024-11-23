//
//  DashboardViewModelTests.swift
//  CryptoTrackerTests
//
//  Created by Ranbijay SinghDeo on 22/11/24.
//

import Foundation
import XCTest
@testable import CryptoTracker

class DashboardViewModelTests: XCTestCase {

    var viewModel: DashboardViewModel!
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
//    func testFetchCoinsSuccess() {
//            let mockService = MockNetworkService()
//        mockService.coinsToReturn = [Coin(uuid: "1", name: "Bitcoin", price: "50000", rank: 1)]
//            
//            let viewModel = DashboardViewModel(networkService: mockService)
//            let expectation = XCTestExpectation(description: "Fetch coins success")
//            
//            viewModel.didUpdateCoins = {
//                XCTAssertEqual(viewModel.allCoins.count, 1)
//                XCTAssertEqual(viewModel.allCoins.first?.name, "Bitcoin")
//                expectation.fulfill()
//            }
//            
//            viewModel.fetchCoins()
//            wait(for: [expectation], timeout: 5.0)
//        }
//        
//        func testFetchCoinsFailure() {
//            let mockService = MockNetworkService()
//            mockService.errorToReturn = NSError(domain: "TestError", code: 123, userInfo: nil)
//            
//            let viewModel = DashboardViewModel(networkService: mockService)
//            let expectation = XCTestExpectation(description: "Fetch coins failure")
//            
//            viewModel.didEncounterError = { errorMessage in
//                XCTAssertEqual(errorMessage, "The operation couldn’t be completed. (TestError error 123.)")
//                expectation.fulfill()
//            }
//            
//            viewModel.fetchCoins()
//            wait(for: [expectation], timeout: 5.0)
//        }
}
