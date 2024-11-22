//
//  Dashboard.swift
//  CryptoTracker
//
//  Created by Ranbijay SinghDeo on 22/11/24.
//

import Foundation
import UIKit

class Dashboard: UIViewController {
    @IBOutlet weak var filterSegment: UISegmentedControl!
    @IBOutlet weak var cryptoTableView: UITableView!
    private var allCoins: [Coin] = []
    private var currentPage = 0
    private var isLoading = false
    var filteredCoins: [Coin] = []
    var favoriteCoins: [Coin] = []       // Favorite coins

    var reuseIdentifier: String?
    override func viewDidLoad() {
        cryptoTableView.delegate = self
        cryptoTableView.dataSource = self
        reuseIdentifier = "CryptoCellIdentifier"
        cryptoTableView.backgroundColor = UIColor.systemGroupedBackground
        cryptoTableView.backgroundColor = UIColor(red: 37/255, green: 47/255, blue: 62/255, alpha: 1)
        cryptoTableView.translatesAutoresizingMaskIntoConstraints = false
        cryptoTableView.separatorColor = UIColor.black // Set separator color to black
        cryptoTableView.separatorInset = .zero        // Make separator span the full width
            
        self.view.backgroundColor = UIColor(red: 37/255, green: 47/255, blue: 62/255, alpha: 1)
        fetchCoins()
        filterSegment.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        filterSegment.backgroundColor = UIColor(red: 37/255, green: 47/255, blue: 62/255, alpha: 1)

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

            // Add to the view
            filterSegment.backgroundColor = UIColor.darkGray
            filterSegment.selectedSegmentTintColor = UIColor.white
            filterSegment.translatesAutoresizingMaskIntoConstraints = false
        setupNavigationBar()
//        addGradientBackground()
    }
    private func addGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.systemTeal.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        let gradientView = UIView(frame: view.bounds)
        gradientView.layer.addSublayer(gradientLayer)
        self.view.insertSubview(gradientView, belowSubview: cryptoTableView)
    }

    func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }

        let titleLabel = UILabel()
        titleLabel.text = "Dashboard"
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 24) // Large bold font
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        navigationBar.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -8)
        ])

    }

    private func fetchCoins() {
        guard !isLoading else { return }
        isLoading = true
        print("Current page value = \(currentPage)")
        NetworkManager.shared.fetchCryptocurrencies(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let newCoins):
                    self.allCoins.append(contentsOf: newCoins)
                    self.filteredCoins.append(contentsOf: newCoins)
                    self.currentPage += 1
                    self.cryptoTableView.reloadData()
                case .failure(let error):
                    print("Error fetching coins: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension Dashboard: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier ?? "", for: indexPath) as! CryptoCell
        let crypto = filteredCoins[indexPath.row]
        cell.nameLabel.text = crypto.name
        cell.symbolLabel.text = crypto.symbol
        if let priceString = crypto.price, let price = Double(priceString) {
            cell.cryptoPriceLabel.text = "$\(String(format: "%.1f", price))"
        } else {
            cell.cryptoPriceLabel.text = "N/A"
        }
        
        if let changeString = crypto.change, let change = Double(changeString) {
            cell.cryptoChangeLabel.text = "\(String(format: "%.1f", change))%"
            cell.cryptoChangeLabel.textColor = change < 0 ? .red : UIColor(red: 124/255, green: 184/255, blue: 32/255, alpha: 1)
        } else {
            cell.cryptoChangeLabel.text = "N/A"
        }
        print("Icon url == \(String(describing: crypto.iconURL))")
        if let iconUrlString = crypto.iconURL, let url = URL(string: iconUrlString) {
            cell.cryptoIconImage.loadImage(from: url, placeholder: UIImage(named: "bitcoin"))
        }
        cell.containerView.backgroundColor = UIColor(red: 37/255, green: 47/255, blue: 62/255, alpha: 1)
        cell.containerView.layer.cornerRadius = 10
        cell.containerView.layer.shadowColor = UIColor.black.cgColor
        cell.containerView.layer.shadowOpacity = 0.1
        cell.containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.containerView.layer.shadowRadius = 4
        
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
        
        cell.backgroundColor = UIColor(red: 37/255, green: 47/255, blue: 62/255, alpha: 1)
        cell.selectionStyle = .none
        cell.favIconImage.image = UIImage(systemName: "star") // Replace with your favorite icon
        cell.favIconImage.tintColor = .systemYellow
        cell.favIconImage.isHidden = true
        cell.favIconImage.translatesAutoresizingMaskIntoConstraints = false


        cell.configure(with: crypto, isFavorite: favoriteCoins.contains(where: { $0.uuid == crypto.uuid }))

        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let coin = allCoins[indexPath.row]
            let isFavorite = favoriteCoins.contains(where: { $0.uuid == coin.uuid })

            // Create swipe action
            let favoriteAction = UIContextualAction(style: .normal, title: isFavorite ? "Unfavorite" : "Favorite") { [weak self] _, _, completionHandler in
                guard let self = self else { return }

                if isFavorite {
                    // Remove from favorites
                    self.favoriteCoins.removeAll(where: { $0.uuid == coin.uuid })
                    self.showToast(message: "\(coin.name ?? "Coin") removed from favorites")
                } else {
                    // Add to favorites
                    self.favoriteCoins.append(coin)
                    self.showToast(message: "\(coin.name ?? "Coin") added to favorites")
                }

                // Reload the affected row
                tableView.reloadRows(at: [indexPath], with: .automatic)
                completionHandler(true)
            }

            favoriteAction.backgroundColor = isFavorite ? .red : .systemBlue
            let configuration = UISwipeActionsConfiguration(actions: [favoriteAction])
            return configuration
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
extension UIViewController {
    func showToast(message: String, duration: TimeInterval = 2.0) {
        // Create a toast label
        let toastLabel = PaddedLabel()
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.textColor = UIColor.darkGray
        toastLabel.backgroundColor = UIColor.white
        toastLabel.numberOfLines = 0
        toastLabel.layer.cornerRadius = 8
        toastLabel.layer.masksToBounds = true
        toastLabel.translatesAutoresizingMaskIntoConstraints = false

        // Add the label to the view
        view.addSubview(toastLabel)

        NSLayoutConstraint.activate([
            toastLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            toastLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])

        // Animate fade-in and fade-out
        UIView.animate(withDuration: 0.3, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}


// Add padding support for UILabel
class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: textInsets)
        super.drawText(in: insetRect)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}

extension Dashboard {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            fetchCoins()
        }
    }
}

extension Dashboard {
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            filteredCoins = allCoins
        case 1:
            filteredCoins = allCoins.filter { $0.rank ?? 0 <= 100 }
        case 2:
            filteredCoins = allCoins.sorted { (Double($0.price ?? "0") ?? 0) > (Double($1.price ?? "0") ?? 0) }
        default:
            break
        }
        cryptoTableView.reloadData() // Refresh the table view
    }
}
