//
//  Utilities.swift
//  CryptoTracker
//
//  Created by Ranbijay SinghDeo on 22/11/24.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        self.image = placeholder
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  error == nil,
                  let image = UIImage(data: data) else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}


class Utility {
    static let shared = Utility()
    private init() {}
    private var activityIndicator: UIActivityIndicatorView?
    private static var loaderBackgroundView: UIView?
    
    func showToast(message: String, view: UIView) {
        let toastLabel = PaddedLabel()
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.textColor = ColorUtility.toastTextColor
        toastLabel.backgroundColor = ColorUtility.toastBackgroundColor
        toastLabel.numberOfLines = 0
        toastLabel.layer.cornerRadius = 8
        toastLabel.layer.masksToBounds = true
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(toastLabel)
        NSLayoutConstraint.activate([
            toastLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            toastLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            toastLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
        
        UIView.animate(withDuration: 0.3, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: Constants.toastDuration, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
    
    static func showLoader(on view: UIView) {
        if loaderBackgroundView == nil {
            loaderBackgroundView = UIView(frame: view.bounds)
            loaderBackgroundView?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            let loaderContainer = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
            loaderContainer.center = loaderBackgroundView!.center
            loaderContainer.backgroundColor = .white
            loaderContainer.layer.cornerRadius = 10
            loaderContainer.clipsToBounds = true
            
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .gray
            activityIndicator.center = CGPoint(x: loaderContainer.bounds.midX, y: loaderContainer.bounds.midY)
            activityIndicator.startAnimating()
            loaderContainer.addSubview(activityIndicator)
            loaderBackgroundView?.addSubview(loaderContainer)
            view.addSubview(loaderBackgroundView!)
        }
        loaderBackgroundView?.isHidden = false
        view.bringSubviewToFront(loaderBackgroundView!)
    }
    
    static func hideLoader() {
        loaderBackgroundView?.removeFromSuperview()
        loaderBackgroundView = nil
    }
    
    static func showPopup(on viewController: UIViewController, title: String, message: String, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    // MARK: - Formatting Helpers
    static func formattedPrice(from price: String?) -> String {
        guard let price = price, let doublePrice = Double(price) else {
            return Constants.Placeholders.notAvailable
        }
        return String(format: "$%.2f", doublePrice)
    }
    
    static func formattedChange(from change: String?) -> String {
        guard let change = change, let doubleChange = Double(change) else {
            return Constants.Placeholders.notAvailable
        }
        return "\(String(format: "%.2f", doubleChange))%"
    }
    
    static func changeColor(from change: String?) -> UIColor {
        guard let change = change, let doubleChange = Double(change) else {
            return .white
        }
        return doubleChange < 0 ? .red : .green
    }
    
    static func formattedSupply(from supply: String?) -> String {
        guard let supply = supply, let doubleSupply = Double(supply) else {
            return Constants.Placeholders.notAvailable
        }
        return String(format: "%.3f", doubleSupply)
    }
    
    // MARK: - UI Setup Helpers
    static func setupLabel(_ label: UILabel, font: UIFont, textColor: UIColor) {
        label.font = font
        label.textColor = textColor
    }
    
    static func setupSegmentControl(_ segmentControl: UISegmentedControl) {
        segmentControl.backgroundColor = ColorUtility.detailsBackgroundColor
        segmentControl.selectedSegmentTintColor = .white
        segmentControl.setTitleTextAttributes(Constants.FontName.segmentUnselected, for: .normal)
        segmentControl.setTitleTextAttributes(Constants.FontName.segmentSelected, for: .selected)
    }
    
    static func setupCardView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorUtility.detailsCardBackground
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
    }
    
    static func setupTextView(_ textView: UITextView) {
        textView.backgroundColor = ColorUtility.detailsCardBackground
        textView.isEditable = false
        textView.textColor = .white
    }
    private func formattedLinks(from links: [DetailsCryptoLink]?) -> String {
        guard let links = links else {
            return Constants.Placeholders.notAvailable
        }
        let urls = links.compactMap { $0.url }
        return urls.isEmpty ? Constants.Placeholders.notAvailable : urls.joined(separator: "\n")
    }
}
