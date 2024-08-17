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
    
    @IBOutlet weak var stackView: UIStackView!
    
    var selectedRecipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImageAppearance()
        setStackView()
        
        if let recipe = selectedRecipe {
            recipeName.text = recipe.label
            if let imageUrl = URL(string: recipe.image) {
                recipeImage.kf.setImage(with: imageUrl)
            }
        }
        
    }
    
    private func setImageAppearance(){
        recipeImage.layer.cornerRadius = 20
        recipeImage.clipsToBounds = true
        recipeImage.layer.borderWidth = 1.0
        recipeImage.layer.borderColor = UIColor.lightGray.cgColor
        recipeImage.contentMode = .scaleToFill
        
    }
    private func setStackView() {
            stackView.layer.cornerRadius = 20
            stackView.clipsToBounds = true
            stackView.backgroundColor = UIColor.systemGray6
            
            guard let recipe = selectedRecipe else { return }
            
            let totalTimeTxt = "\(recipe.totalTime) Min"
            let totalWeightTxt = "\(recipe.totalWeight) g"
            let totalCalTxt = "\(recipe.calories) cal"
            
            let timeView = createItemView(iconName: "clock", text: totalTimeTxt)
            let stepsView = createItemView(iconName: "weight", text: totalWeightTxt)
            let difficultyView = createItemView(iconName: "calories", text: totalCalTxt)
            
            stackView.addArrangedSubview(timeView)
            stackView.addArrangedSubview(stepsView)
            stackView.addArrangedSubview(difficultyView)
        }
        
        private func createItemView(iconName: String, text: String) -> UIView {
            let itemStackView = UIStackView()
            itemStackView.axis = .vertical
            itemStackView.alignment = .center
            itemStackView.spacing = 3
            
            let imageView = UIImageView(image: UIImage(named: iconName))
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .systemBlue
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 38).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
            let label = UILabel()
            label.text = text
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            label.textColor = .black
            label.textAlignment = .center
            
            itemStackView.addArrangedSubview(imageView)
            itemStackView.addArrangedSubview(label)
            
            return itemStackView
                }
    
    @IBAction func goBack(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }

}
