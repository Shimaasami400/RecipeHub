//
//  RecipeCollectionViewCell.swift
//  RecipeHub
//
//  Created by Shimaa on 16/08/2024.
//

import UIKit
import Kingfisher

class RecipeCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeSource: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        recipeImage.layer.cornerRadius = 10
        recipeImage.clipsToBounds = true
    }
    func configure(with recipe: Recipe) {
        recipeName.text = recipe.label
        recipeSource.text = recipe.source
        if let imageUrl = URL(string: recipe.image) {
            recipeImage.kf.setImage(with: imageUrl)
        }
    }
    
    private func loadImage(from url: URL, into imageView: UIImageView) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }
            }
        }
    }
}
