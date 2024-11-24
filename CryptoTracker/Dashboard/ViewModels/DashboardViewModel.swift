//
//  DashboardViewModel.swift
//  CryptoTracker
//
//  Created by Ranbijay SinghDeo on 22/11/24.
//

import Foundation


protocol CryptoViewModelDelegate: AnyObject {
    func didUpdateCoins()
}

class DashboardViewModel {
    weak var delegate: CryptoViewModelDelegate?
    private let networkService: NetworkService
    var allCoins: [Coin] = []
    var favoriteCoins: [Coin] = []
    private(set) var filteredCoins: [Coin] = []
    var currentPage = 0
    var isLoading = false
    
    var didUpdateCoins: (() -> Void)?
    var didEncounterError: ((String) -> Void)?
    init(networkService: NetworkService = NetworkManager.shared) {
        self.networkService = networkService
    }
    func fetchCoins() {
        guard !isLoading else { return }
        isLoading = true
        
        NetworkManager.shared.fetchCryptocurrencies(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let newCoins):
                    if !newCoins.isEmpty {
                        self.allCoins.append(contentsOf: newCoins)
                        self.filteredCoins.append(contentsOf: newCoins)
                        self.currentPage += 1
                        self.delegate?.didUpdateCoins()
                    }
                case .failure(let error):
                    print("Error fetching coins: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func filterCoins(by segmentIndex: Int) {
        switch segmentIndex {
        case 0:
            filteredCoins = allCoins
        case 1:
            filteredCoins = allCoins.filter { $0.rank ?? 0 <= 100 }
        case 2:
            filteredCoins = allCoins.sorted { (Double($0.price ?? "0") ?? 0) > (Double($1.price ?? "0") ?? 0) }
        case 3:
            filteredCoins = favoriteCoins
        default:
            break
        }
        didUpdateCoins?()
    }
    
    func toggleFavorite(for coin: Coin) -> Bool {
        if let index = favoriteCoins.firstIndex(where: { $0.uuid == coin.uuid }) {
            favoriteCoins.remove(at: index)
            return false
        } else {
            favoriteCoins.append(coin)
            return true
        }
    }
    
    func addFavorite(_ coin: Coin) {
        if !favoriteCoins.contains(where: { $0.uuid == coin.uuid }) {
            favoriteCoins.append(coin)
        }
    }
    
    func removeFavorite(_ coin: Coin) {
        favoriteCoins.removeAll { $0.uuid == coin.uuid }
    }
}
