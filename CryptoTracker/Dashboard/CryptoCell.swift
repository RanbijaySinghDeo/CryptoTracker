//
//  CryptoCell.swift
//  CryptoTracker
//
//  Created by Ranbijay SinghDeo on 22/11/24.
//

import Foundation
import UIKit

class CryptoCell: UITableViewCell {
    
    @IBOutlet weak var favIconImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cryptoPriceLabel: UILabel!
    @IBOutlet weak var cryptoIconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cryptoChangeLabel: UILabel!
    
    @IBOutlet weak var symbolLabel: UILabel!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
     }

     required init?(coder: NSCoder) {
         // Provide a default implementation
         super.init(coder: coder)
     }

    func configure(with coin: Coin, isFavorite: Bool) {
            favIconImage.isHidden = !isFavorite
        }
}
