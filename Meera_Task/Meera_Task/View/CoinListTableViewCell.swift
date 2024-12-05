//
//  CoinListTableViewCell.swift
//  Meera_Task
//
//  Created by Meera Seetharam on 30/11/24.
//

import UIKit

class CoinListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var tagLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let radiansAngle: CGFloat = 45.0 * .pi / 180.0
        tagLabel.transform = CGAffineTransform(rotationAngle: radiansAngle)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(model: Coin) {
        self.nameLabel.text = model.name
        self.symbolLabel.text = model.symbol
        if model.isActive {
            self.typeImageView.image = UIImage(named: model.type)
        } else {
            self.typeImageView.image = UIImage(named: "inactive")
        }
        self.tagLabel.isHidden = !model.isNew
    }
}
