//
//  SearchRecipeViewController.swift
//  RecipeHub
//
//  Created by Shimaa on 15/08/2024.
//

import UIKit
import RxSwift
import RxCocoa

class SearchRecipeViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate {
    
    
    @IBOutlet weak var recipeSearchBar: UISearchBar!
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel = SearchRecipeViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        recipeSearchBar.delegate = self
        
        configureCollectionView()
        customizeSearchBar()
        setupBindings()
        
    }
    private func configureCollectionView() {
        
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 5
            
            let itemWidth = (collectionView.bounds.width - 30) / 2
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 70)
            
            collectionView.collectionViewLayout = layout
            collectionView.register(UINib(nibName: "RecipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecipeCell")
            
            collectionView.delegate = self
        }
    
    private func customizeSearchBar() {
        recipeSearchBar.backgroundImage = UIImage()
        
        if let textField = recipeSearchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            textField.layer.cornerRadius = 10
            textField.clipsToBounds = true
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor.lightGray.cgColor
            textField.attributedPlaceholder = NSAttributedString(string: "Search recipes", attributes: [.foregroundColor: UIColor.lightGray])
        }
    }
    
    private func setupBindings() {
        viewModel.recipes
            .bind(to: collectionView.rx.items(cellIdentifier: "RecipeCell", cellType: RecipeCollectionViewCell.self)) { (row, recipe, cell) in
                cell.configure(with: recipe)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Recipe.self)
            .subscribe(onNext: { [weak self] recipe in
                self?.navigateToDetails(with: recipe)
            })
            .disposed(by: disposeBag)
    }
    
    private func navigateToDetails(with recipe: Recipe) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsViewController") as? RecipeDetailsViewController {
            detailsVC.selectedRecipe = recipe
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    
    @IBAction func searchButton(_ sender: Any) {
        if let query = recipeSearchBar.text, !query.isEmpty {
            viewModel.searchRecipes(query: query)
        }
    }
    
}


