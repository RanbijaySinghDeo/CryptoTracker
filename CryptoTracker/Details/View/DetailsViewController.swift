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
    @IBOutlet weak var resourcesView: UIView!
    @IBOutlet weak var resourcesLabel: UILabel!
    @IBOutlet weak var resourcesTextView: UITextView!
    @IBOutlet weak var bottonDescriptionTextView: UITextView!
    @IBOutlet weak var bottomDescriptionLabel: UILabel!
    @IBOutlet weak var bottomDescriptionView: UIView!
    var coin: Coin!
    var isFavorite: Bool = false
    var onFavoriteToggle: ((Coin, Bool) -> Void)?
    private let favButton = UIBarButtonItem()
    var coinDetails: DetailsCryptoCoinDetailsResponse!
    private var viewModel: DetailsViewModel!
    private var graphRenderer: GraphRenderer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupSegmentControl()
        initializeViewModel()
        setupGraphRenderer()
        bindViewModel()
        updateUIWithCoinData()
        viewModel.fetchGraphData(for: Constants.Graph.defaultTimePeriod)
        cryptoChangeSegment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    private func initializeViewModel() {
        viewModel = DetailsViewModel(networkService: NetworkManager.shared, coin: coin)
    }
    private func setupGraphRenderer() {
        graphRenderer = GraphRenderer(graphView: cryptoChangeGraphMainView)
    }
    private func bindViewModel() {
        viewModel.didUpdateGraphData = { [weak self] in
            guard let self = self else { return }
            self.graphRenderer.renderGraph(with: self.viewModel.graphPoints(), graphColor: self.viewModel.graphColor())
        }
        
        viewModel.didEncounterError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                if let view = self?.view {
                    Utility.shared.showToast(message: errorMessage, view: view)
                } else {
                    print("Error: Unable to show toast as view is nil")
                }
            }
        }
    }
    
    private func updateUIWithCoinData() {
        let coin = viewModel.coin
        
        // Basic Details
        cryproNameLabel.text = coin.name
        cryptoPriceLabel.text = Utility.formattedPrice(from: coin.price)
        cryptoChangeLabel.text = Utility.formattedChange(from: coin.change)
        cryptoChangeLabel.textColor = Utility.changeColor(from: coin.change)
        
        // Coin Details
        aNameLabel.text = Constants.Labels.nameOfCoin
        aNameValueLabel.text = coinDetails.data?.coin?.name ?? Constants.Placeholders.notAvailable
        
        aSymbolLabel.text = Constants.Labels.symbolOfCoin
        aSymbolValueLabel.text = coinDetails.data?.coin?.symbol ?? Constants.Placeholders.notAvailable
        
        totalSupplyLabel.text = Constants.Labels.totalSupply
        totalSupplyValueLabel.text = Utility.formattedSupply(from: coinDetails.data?.coin?.supply?.total)
        
        marketCapLabel.text = Constants.Labels.marketCap
        marketCapValueLabel.text = coinDetails.data?.coin?.marketCap ?? Constants.Placeholders.notAvailable
        
        rankLabel.text = Constants.Labels.rank
        rankValueLabel.text = "#\(coinDetails.data?.coin?.rank ?? 0)"
        
        allTimeHighLabel.text = Constants.Labels.allTimeHigh
        allTimeHighValueLabel.text = Utility.formattedPrice(from: coinDetails.data?.coin?.allTimeHigh?.price)
        
        circulatingLabel.text = Constants.Labels.circulatingSupply
        circulatingValueLabel.text = Utility.formattedSupply(from: coinDetails.data?.coin?.supply?.circulating)
        
        // Additional Info
        aboutDecsLabel.text = "\(Constants.Labels.about) \(coin.name ?? "")"
        bottonDescriptionTextView.text = coinDetails.data?.coin?.description ?? Constants.Placeholders.notAvailable
        
        guard let links = coinDetails.data?.coin?.links else {
            resourcesTextView.text = "No links available."
            return
        }
        
        let urls = links.compactMap { $0.url }
        
        let urlsText = urls.joined(separator: "\n")
        
        resourcesTextView.text = urlsText
        resourcesTextView.isEditable = false
        resourcesTextView.textColor = .blue
    }
    
    private func setupSegmentControl() {
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
        navigationController?.navigationBar.prefersLargeTitles = false
        favButton.image = UIImage(systemName: isFavorite ? "star.fill" : "star")
        favButton.tintColor = .systemYellow
        favButton.target = self
        favButton.action = #selector(toggleFavorite)
        navigationItem.rightBarButtonItem = favButton
        navigationController?.navigationBar.tintColor = .white
        navigationItem.backButtonTitle = ""
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 37/255, green: 47/255, blue: 62/255, alpha: 1)
        appearance.shadowColor = nil
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupUI() {
        view.backgroundColor = ColorUtility.detailsBackgroundColor
        Utility.setupLabel(cryproNameLabel,
                           font: UIFont(name: Constants.FontName.regular, size: 18)!,
                           textColor: .white)
        Utility.setupLabel(cryptoPriceLabel,
                           font: UIFont(name: Constants.FontName.bold, size: 24)!,
                           textColor: .white)
        Utility.setupLabel(cryptoChangeLabel,
                           font: UIFont(name: Constants.FontName.regular, size: 16)!,
                           textColor: .white)
        Utility.setupSegmentControl(cryptoChangeSegment)
        Utility.setupCardView(descriptionView)
        Utility.setupCardView(resourcesView)
        Utility.setupCardView(bottomDescriptionView)
        Utility.setupTextView(resourcesTextView)
        Utility.setupTextView(bottonDescriptionTextView)
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
