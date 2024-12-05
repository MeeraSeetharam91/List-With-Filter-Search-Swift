//
//  FilterCollectionViewCell.swift
//  Meera_Task
//
//  Created by Meera Seetharam on 03/12/24.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = true
        layer.borderWidth = 1
        layer.cornerRadius = bounds.height / 2
    }

    func setData(model: FilterSelection) {
        self.titleLabel.text = model.filterType.rawValue
        self.selectedImageView.isHidden = !model.isSelected
    }
}
