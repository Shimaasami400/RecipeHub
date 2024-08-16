//
//  RecipeDetailsViewController.swift
//  RecipeHub
//
//  Created by Shimaa on 16/08/2024.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    var selectedRecipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let recipe = selectedRecipe {
            recipeName.text = recipe.label
            if let imageUrl = URL(string: recipe.image) {
                recipeImage.kf.setImage(with: imageUrl)
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
}
