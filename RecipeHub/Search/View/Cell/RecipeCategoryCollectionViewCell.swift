//
//  RecipeCategoryCollectionViewCell.swift
//  RecipeHub
//
//  Created by Shimaa on 17/08/2024.
//

import UIKit

class RecipeCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    
    override var isSelected: Bool {
            didSet {
                let selectedColor = UIColor(red: 226/255, green: 62/255, blue: 62/255, alpha: 1.0)
                contentView.backgroundColor = isSelected ? selectedColor : UIColor.clear
                categoryLabel.textColor = isSelected ? .white : selectedColor
            }
        }

        override func awakeFromNib() {
            super.awakeFromNib()
            contentView.layer.cornerRadius = 15
            contentView.layer.borderWidth = 1.0
            contentView.layer.borderColor = UIColor.clear.cgColor
            contentView.layer.masksToBounds = true
            categoryLabel.textColor = UIColor(red: 226/255, green: 62/255, blue: 62/255, alpha: 1.0) 
        }
    }
