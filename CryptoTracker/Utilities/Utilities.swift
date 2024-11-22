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
    
    func showLoader(on view: UIView) {
            if activityIndicator == nil {
                activityIndicator = UIActivityIndicatorView(style: .large)
                activityIndicator?.center = view.center
                activityIndicator?.hidesWhenStopped = true
                view.addSubview(activityIndicator!)
            }
            
            activityIndicator?.startAnimating()
            activityIndicator?.isHidden = false
            view.bringSubviewToFront(activityIndicator!)
        }
        
        func hideLoader() {
            activityIndicator?.stopAnimating()
            activityIndicator?.isHidden = true
        }
    
}
