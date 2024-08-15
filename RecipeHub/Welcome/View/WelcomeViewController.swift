//
//  WelcomeViewController.swift
//  RecipeHub
//
//  Created by Shimaa on 15/08/2024.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func navigateToSearchScreen(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let searchRecipeViewController = storyboard.instantiateViewController(withIdentifier: "SearchRecipeViewController") as? SearchRecipeViewController {
            navigationController?.pushViewController(searchRecipeViewController, animated: true)
        }

    }
}
