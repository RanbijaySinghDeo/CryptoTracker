//
//  DashboardViewController.swift
//  CryptoTracker
//
//  Created by Ranbijay SinghDeo on 22/11/24.
//

import Foundation
import UIKit

class DashboardViewController: UIViewController {
    @IBOutlet weak var filterSegment: UISegmentedControl!
    @IBOutlet weak var cryptoTableView: UITableView!
    private let viewModel = DashboardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.delegate = self
        viewModel.fetchCoins()
    }
    
    private func setupUI() {
        view.backgroundColor = ColorUtility.backgroundColor
        setupNavigationBar()
        setupTableView()
        setupSegmentControl()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backgroundColor = ColorUtility.backgroundColor
        navigationItem.backButtonTitle = ""
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = ColorUtility.backgroundColor
        appearance.shadowColor = nil
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupTableView() {
        cryptoTableView.delegate = self
        cryptoTableView.dataSource = self
        cryptoTableView.backgroundColor = ColorUtility.backgroundColor
        cryptoTableView.separatorColor = ColorUtility.separatorColor
        cryptoTableView.separatorInset = .zero
    }
    
    private func setupSegmentControl() {
        filterSegment.backgroundColor = ColorUtility.backgroundColor
        filterSegment.selectedSegmentTintColor = UIColor.white
        
        let unselectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14)
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 14)
        ]
        
        filterSegment.setTitleTextAttributes(unselectedAttributes, for: .normal)
        filterSegment.setTitleTextAttributes(selectedAttributes, for: .selected)
        filterSegment.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    private func bindViewModel() {
        viewModel.didUpdateCoins = { [weak self] in
            self?.cryptoTableView.reloadData()
        }
        
        viewModel.didEncounterError = { errorMessage in
            Utility.shared.showToast(message: errorMessage, view: self.view)
        }
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        viewModel.filterCoins(by: sender.selectedSegmentIndex)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            viewModel.fetchCoins()
        }
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let coin = viewModel.filteredCoins[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cryptoCellReuseIdentifier, for: indexPath) as! CryptoCell
        configureCell(cell, with: coin)
        
        return cell
    }
    
    private func configureCell(_ cell: CryptoCell, with coin: Coin) {
        cell.nameLabel.text = coin.name
        cell.symbolLabel.text = coin.symbol
        
        if let price = coin.price, let fPrice = Double(price) {
            cell.cryptoPriceLabel.text = "\(String(format: "%.1f", fPrice))"
        } else {
            cell.cryptoChangeLabel.text = Constants.Placeholders.notAvailable
        }
        
        if let changeString = coin.change, let change = Double(changeString) {
            cell.cryptoChangeLabel.text = "\(String(format: "%.1f", change))%"
            cell.cryptoChangeLabel.textColor = change < 0 ? .red : UIColor(red: 124/255, green: 184/255, blue: 32/255, alpha: 1)
        } else {
            cell.cryptoChangeLabel.text = Constants.Placeholders.notAvailable
        }
        
        if let iconUrlString = coin.iconURL, let url = URL(string: iconUrlString) {
            cell.cryptoIconImage.loadImage(from: url, placeholder: UIImage(named: "bitcoin"))
        }
        let isFavorite = viewModel.favoriteCoins.contains(where: { $0.uuid == coin.uuid })
        cell.favIconImage.isHidden = !isFavorite
        
        styleCell(cell, isFavorite)
    }
    
    private func styleCell(_ cell: CryptoCell, _ isFavorite: Bool) {
        cell.containerView.backgroundColor = UIColor(red: 37/255, green: 47/255, blue: 62/255, alpha: 1)
        cell.nameLabel.font = UIFont(name: "HelveticaNeue", size: 18)
        cell.nameLabel.textColor = .white
        cell.nameLabel.backgroundColor = .clear
        
        cell.symbolLabel.font = UIFont(name: "HelveticaNeue", size: 12)
        cell.symbolLabel.textColor = .lightGray
        cell.symbolLabel.backgroundColor = .clear
        
        cell.cryptoPriceLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        cell.cryptoPriceLabel.textColor = .white
        cell.cryptoPriceLabel.backgroundColor = .clear
        
        cell.cryptoChangeLabel.font = UIFont(name: "HelveticaNeue", size: 18)
        cell.cryptoChangeLabel.backgroundColor = .clear
        
        cell.cryptoIconImage.layer.cornerRadius = 25
        cell.cryptoIconImage.layer.masksToBounds = true
        cell.cryptoIconImage.backgroundColor = .clear
        
        cell.favIconImage.image = UIImage(systemName: "star")
        cell.favIconImage.tintColor = .systemYellow
        cell.favIconImage.isHidden = !isFavorite
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let coin = viewModel.filteredCoins[indexPath.row]
        let isFavorite = viewModel.favoriteCoins.contains(where: { $0.uuid == coin.uuid })
        
        let favoriteAction = UIContextualAction(style: .normal, title: isFavorite ? "Unfavorite" : "Favorite") { _, _, completionHandler in
            let action = self.viewModel.toggleFavorite(for: coin)
            Utility.shared.showToast(message: "\(coin.name ?? "Coin") \(action ? "added to" : "removed from") favorites", view: self.view)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        
        favoriteAction.backgroundColor = isFavorite ? ColorUtility.unfavoriteButtonColor : ColorUtility.favoriteButtonColor
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension DashboardViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = viewModel.filteredCoins[indexPath.row]
        let isFavorite = viewModel.favoriteCoins.contains(where: { $0.uuid == coin.uuid })
        
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.center = self.view.center
        loadingIndicator.startAnimating()
        self.view.addSubview(loadingIndicator)
        
        NetworkManager.shared.fetchCoinDetails(uuid: coin.uuid ?? "") { [weak self] result in
            DispatchQueue.main.async {
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
                
                switch result {
                case .success(let coinDetailsResponse):
                    if let detailsVC = self?.instantiateDetailsViewController(with: coin, isFavorite: isFavorite, coinDetailsResponse: coinDetailsResponse) {
                        self?.navigationController?.pushViewController(detailsVC, animated: true)
                    }
                    
                case .failure(let error):
                    guard let self = self else { return }
                    Utility.shared.showToast(message: "Failed to load coin details: \(error.localizedDescription)", view: self.view)
                }
            }
        }
    }
    
    
    private func instantiateDetailsViewController(with coin: Coin, isFavorite: Bool, coinDetailsResponse: DetailsCryptoCoinDetailsResponse) -> DetailsViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(identifier: "DetailsViewController") as? DetailsViewController {
            detailsVC.coin = coin
            detailsVC.isFavorite = isFavorite
            detailsVC.coinDetails = coinDetailsResponse
            
            detailsVC.onFavoriteToggle = { [weak self] updatedCoin, isNowFavorite in
                guard let self = self else { return }
                if isNowFavorite {
                    self.viewModel.addFavorite(updatedCoin)
                } else {
                    self.viewModel.removeFavorite(updatedCoin)
                }
                self.cryptoTableView.reloadData()
            }
            
            return detailsVC
        }
        return nil
    }
}

extension DashboardViewController: CryptoViewModelDelegate {
    func didUpdateCoins() {
        cryptoTableView.reloadData()
    }
}
