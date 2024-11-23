//
//  DetailsViewController.swift
//  CryptoTracker
//
//  Created by Ranbijay SinghDeo on 23/11/24.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var cryptoChangeSegment: UISegmentedControl!
    @IBOutlet weak var cryptoChangeGraphMainView: UIView!
    @IBOutlet weak var cryptoChangeLabel: UILabel!
    @IBOutlet weak var cryptoPriceLabel: UILabel!
    @IBOutlet weak var cryproNameLabel: UILabel!
    @IBOutlet weak var aNameLabel: UILabel!
    @IBOutlet weak var aNameValueLabel: UILabel!
    @IBOutlet weak var aSymbolLabel: UILabel!
    @IBOutlet weak var aSymbolValueLabel: UILabel!
    @IBOutlet weak var totalSupplyLabel: UILabel!
    @IBOutlet weak var totalSupplyValueLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var marketCapValueLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var rankValueLabel: UILabel!
    @IBOutlet weak var allTimeHighLabel: UILabel!
    @IBOutlet weak var allTimeHighValueLabel: UILabel!
    @IBOutlet weak var circulatingLabel: UILabel!
    @IBOutlet weak var circulatingValueLabel: UILabel!
    @IBOutlet weak var aboutDecsLabel: UILabel!
    @IBOutlet weak var descriptionView: UIView!
    var coin: Coin!
    var isFavorite: Bool = false
    var onFavoriteToggle: ((Coin, Bool) -> Void)?
    private let favButton = UIBarButtonItem()
    var coinDetails: DetailsCryptoCoinDetailsResponse!
    private var viewModel: DetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupSegmentControl()
        initializeViewModel()
        bindViewModel()
        updateUIWithCoinData()
        
        viewModel.fetchGraphData(for: Constants.Graph.defaultTimePeriod)
    }
    
    private func initializeViewModel() {
        viewModel = DetailsViewModel(networkService: NetworkManager.shared, coin: coin)
    }
    
    private func bindViewModel() {
        viewModel.didUpdateGraphData = { [weak self] in
            self?.drawGraph()
        }
        
        viewModel.didEncounterError = { errorMessage in
            DispatchQueue.main.async {
                Utility.shared.showToast(message: errorMessage, view: self.view)
            }
        }
    }
    
    private func updateUIWithCoinData() {
        let coin = viewModel.coin
        
        cryproNameLabel.text = coin.name
        
        if let price = coin.price, let formattedPrice = Double(price) {
            cryptoPriceLabel.text = "$\(String(format: "%.2f", formattedPrice))"
        } else {
            cryptoPriceLabel.text = Constants.Placeholders.notAvailable
        }
        
        if let change = coin.change, let formattedChange = Double(change) {
            cryptoChangeLabel.text = "\(String(format: "%.2f", formattedChange))%"
            cryptoChangeLabel.textColor = formattedChange < 0 ? .red : .green
        } else {
            cryptoChangeLabel.text = Constants.Placeholders.notAvailable
        }
        aNameLabel.text = Constants.Labels.nameOfCoin
        aNameValueLabel.text = coinDetails.data?.coin?.name
        
        aSymbolLabel.text = Constants.Labels.symbolOfCoin
        aSymbolValueLabel.text = coinDetails.data?.coin?.symbol
        
        totalSupplyLabel.text = Constants.Labels.totalSupply
        if let total = coinDetails.data?.coin?.supply?.total,
           let circulatingValue = Double(total) {
            totalSupplyValueLabel.text = String(format: "%.3f", circulatingValue)
        } else {
            totalSupplyValueLabel.text = Constants.Placeholders.notAvailable
        }
        
        marketCapLabel.text = Constants.Labels.marketCap
        marketCapValueLabel.text = coinDetails.data?.coin?.marketCap
        
        rankLabel.text = Constants.Labels.rank
        rankValueLabel.text = "#\(coinDetails.data?.coin?.rank ?? 0)"
        
        allTimeHighLabel.text = Constants.Labels.allTimeHigh
        if let priceString = coinDetails.data?.coin?.allTimeHigh?.price,
           let priceValue = Double(priceString) {
            allTimeHighValueLabel.text = String(format: "%.3f", priceValue)
        } else {
            allTimeHighValueLabel.text = Constants.Placeholders.notAvailable
        }
        
        
        circulatingLabel.text = Constants.Labels.circulatingSupply
        if let circulatingString = coinDetails.data?.coin?.supply?.circulating,
           let circulatingValue = Double(circulatingString) {
            circulatingValueLabel.text = String(format: "%.3f", circulatingValue)
        } else {
            circulatingValueLabel.text = Constants.Placeholders.notAvailable
        }
        
        aboutDecsLabel.text = "\(Constants.Labels.about) \(coin.name ?? "")"
        
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.backgroundColor = UIColor(red: 48/255, green: 55/255, blue: 67/255, alpha: 0.8)
        descriptionView.layer.cornerRadius = 12
        descriptionView.layer.masksToBounds = true
        
    }
    
    private func setupSegmentControl() {
        cryptoChangeSegment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    @objc private func segmentChanged() {
        let selectedTimePeriod: String
        switch cryptoChangeSegment.selectedSegmentIndex {
        case 0: selectedTimePeriod = Constants.Graph.timePeriods[0]
        case 1: selectedTimePeriod = Constants.Graph.timePeriods[1]
        case 2: selectedTimePeriod = Constants.Graph.timePeriods[2]
        case 3: selectedTimePeriod = Constants.Graph.timePeriods[3]
        case 4: selectedTimePeriod = Constants.Graph.timePeriods[4]
        default: selectedTimePeriod = Constants.Graph.defaultTimePeriod
        }
        viewModel.fetchGraphData(for: selectedTimePeriod)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = coin.name
        navigationController?.navigationBar.prefersLargeTitles = false
        favButton.image = UIImage(systemName: isFavorite ? "star.fill" : "star")
        favButton.tintColor = .systemYellow
        favButton.target = self
        favButton.action = #selector(toggleFavorite)
        navigationItem.rightBarButtonItem = favButton
        navigationController?.navigationBar.tintColor = .white
        navigationItem.backButtonTitle = ""
    }
    
    private func setupUI() {
        view.backgroundColor = ColorUtility.backgroundColor
        cryproNameLabel.font = UIFont(name: "HelveticaNeue", size: 18)
        cryproNameLabel.textColor = .white
        
        cryptoPriceLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        cryptoPriceLabel.textColor = .white
        
        cryptoChangeLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        cryptoChangeLabel.textColor = .white
        
        cryptoChangeSegment.backgroundColor = ColorUtility.backgroundColor
        cryptoChangeSegment.selectedSegmentTintColor = .white
        let unselectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14)
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 14)
        ]
        cryptoChangeSegment.setTitleTextAttributes(unselectedAttributes, for: .normal)
        cryptoChangeSegment.setTitleTextAttributes(selectedAttributes, for: .selected)
    }
    
    private func drawGraph() {
        cryptoChangeGraphMainView.subviews.forEach { $0.removeFromSuperview() }
        cryptoChangeGraphMainView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        guard !viewModel.graphData.isEmpty else { return }
        let points = viewModel.graphData.map { $0.price }
        let maxPrice = points.max() ?? 0.0
        let minPrice = points.min() ?? 0.0
        let graphBackground = UIView(frame: cryptoChangeGraphMainView.bounds)
        graphBackground.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        graphBackground.layer.cornerRadius = 10
        graphBackground.clipsToBounds = true
        cryptoChangeGraphMainView.addSubview(graphBackground)
        let maxLabel = UILabel()
        maxLabel.text = "\(Constants.Labels.high) \(String(format: "$%.2f", maxPrice))"
        maxLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        maxLabel.textColor = UIColor.darkGray
        maxLabel.sizeToFit()
        maxLabel.frame.origin = CGPoint(x: 10, y: 5)
        graphBackground.addSubview(maxLabel)
        let minLabel = UILabel()
        minLabel.text = "\(Constants.Labels.low) \(String(format: "$%.2f", minPrice))"
        minLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        minLabel.textColor = UIColor.darkGray
        minLabel.sizeToFit()
        minLabel.frame.origin = CGPoint(x: 10, y: graphBackground.bounds.height - minLabel.bounds.height - 5)
        graphBackground.addSubview(minLabel)
        let path = UIBezierPath()
        for (index, price) in points.enumerated() {
            let xPosition = CGFloat(index) * (graphBackground.frame.width / CGFloat(points.count - 1))
            let yPosition = graphBackground.frame.height - ((CGFloat(price - minPrice) / CGFloat(maxPrice - minPrice)) * graphBackground.frame.height)
            
            let point = CGPoint(x: xPosition, y: yPosition)
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        
        let graphLayer = CAShapeLayer()
        graphLayer.path = path.cgPath
        graphLayer.strokeColor = viewModel.graphColor().cgColor
        graphLayer.fillColor = UIColor.clear.cgColor
        graphLayer.lineWidth = 1.5 // Thinner line
        graphBackground.layer.addSublayer(graphLayer)
    }
    
    private func updateChangeLabel() {
        cryptoChangeLabel.text = "\(viewModel.coin.change ?? "0")%"
        cryptoChangeLabel.textColor = viewModel.isProfit ? .green : .red
    }
    
    @objc private func toggleFavorite() {
        isFavorite.toggle()
        favButton.image = UIImage(systemName: isFavorite ? "star.fill" : "star")
        onFavoriteToggle?(coin, isFavorite)
    }
}
