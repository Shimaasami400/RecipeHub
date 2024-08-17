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
        recipeImage.layer.borderColor = UIColor(red: 226/255, green: 62/255, blue: 62/255, alpha: 1.0).cgColor
        //recipeImage.layer.borderColor = UIColor.lightGray.cgColor
        recipeImage.contentMode = .scaleToFill
        
    }
    
    private func setStackView() {
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 20

        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 20
        stackView.layer.borderWidth = 1.0
        stackView.layer.borderColor = UIColor(red: 226/255, green: 62/255, blue: 62/255, alpha: 1.0).cgColor
        stackView.clipsToBounds = true

        guard let recipe = selectedRecipe else { return }

        let totalTimeTxt = String(format: "%.1f min", recipe.totalTime)
        let totalWeightTxt = String(format: "%.1f g", recipe.totalWeight)
        let difficultyTxt = String(format: "%.1f kcal", recipe.calories)

        let timeView = createItemView(iconName: "clock", text: totalTimeTxt)
        let stepsView = createItemView(iconName: "weight", text: totalWeightTxt)
        let difficultyView = createItemView(iconName: "calories", text: difficultyTxt)

        stackView.addArrangedSubview(timeView)
        stackView.addArrangedSubview(stepsView)
        stackView.addArrangedSubview(difficultyView)
    }

    private func createItemView(iconName: String, text: String) -> UIView {
        let itemStackView = UIStackView()
        itemStackView.axis = .vertical
        itemStackView.alignment = .center
        itemStackView.spacing = 6

        let imageView = UIImageView(image: UIImage(named: iconName))
            imageView.contentMode = .scaleAspectFit

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true

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
        navigationController?.popViewController(animated: true)
    }

}
