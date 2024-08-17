//
//  SearchRecipeViewController.swift
//  RecipeHub
//
//  Created by Shimaa on 15/08/2024.
//

import UIKit
import RxSwift
import RxCocoa
import Reachability


class SearchRecipeViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate {
    
    
    @IBOutlet weak var recipeSearchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    private let noResultsImageView = UIImageView()
    private let noResultsLabel = UILabel()
    
    private let noInternetImageView = UIImageView()
    private let noInternetLabel = UILabel()
    private var reachability: Reachability?
    private var lastSearch: String = ""
    
    
    private let viewModel = SearchRecipeViewModel()
    private let disposeBag = DisposeBag()
    
    let categories = ["All", "Low Sugar", "Dairy-Free", "Vegan"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeSearchBar.delegate = self
        
        setCollectionView()
        setCategoryCollectionView()
        setSearchBar()
        setupBindings()
        //setupNoResultsUI()
        setupNoInternetUI()
        setupReachability()
        
    }
    
    private func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        let itemWidth = (collectionView.bounds.width - 30) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 70)
        
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: "RecipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecipeCell")
        
        collectionView.delegate = self
    }
    
    private func setCategoryCollectionView() {
        categoryCollectionView.register(UINib(nibName: "RecipeCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 95, height: 38)
        categoryCollectionView.collectionViewLayout = layout
        
        Observable.just(categories)
            .bind(to: categoryCollectionView.rx.items(cellIdentifier: "CategoryCell", cellType: RecipeCategoryCollectionViewCell.self)) { (row, category, cell) in
                cell.categoryLabel.text = category
                //cell.categoryLabel.backgroundColor = .white
            }
            .disposed(by: disposeBag)
        
        categoryCollectionView.rx.modelSelected(String.self)
            .subscribe(onNext: { [weak self] category in
                self?.handleCategorySelection(category)
            })
            .disposed(by: disposeBag)
    }
    
    private func setSearchBar() {
        recipeSearchBar.backgroundImage = UIImage()
        
        if let textField = recipeSearchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            textField.layer.cornerRadius = 10
            textField.clipsToBounds = true
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor.lightGray.cgColor
            textField.attributedPlaceholder = NSAttributedString(string: "Search a recipe", attributes: [.foregroundColor: UIColor.lightGray])
        }
        
        if let textField = recipeSearchBar.value(forKey: "searchField") as? UITextField,
           let imageView = textField.leftView as? UIImageView {
            imageView.isHidden = true
        }
    }
    
    private func handleCategorySelection(_ category: String) {
        let allRecipes = viewModel.recipes.value
        
        let filteredRecipes: [Recipe]
        
        switch category {
        case "All":
            filteredRecipes = allRecipes
        case "Low Sugar":
            filteredRecipes = allRecipes.filter { recipe in
                recipe.healthLabels?.contains("Low Sugar") ?? false
            }
        case "Dairy-Free":
            filteredRecipes = allRecipes.filter { recipe in
                recipe.healthLabels?.contains("Dairy-Free") ?? false
            }
        case "Vegan":
            filteredRecipes = allRecipes.filter { recipe in
                recipe.healthLabels?.contains("Vegan") ?? false
            }
        default:
            filteredRecipes = allRecipes
        }
        
        viewModel.filteredRecipes.accept(filteredRecipes)
    }
    
    private func setupBindings() {
        viewModel.filteredRecipes
            .bind(to: collectionView.rx.items(cellIdentifier: "RecipeCell", cellType: RecipeCollectionViewCell.self)) { (row, recipe, cell) in
                cell.configure(with: recipe)
            }
            .disposed(by: disposeBag)
        
        viewModel.filteredRecipes
            .subscribe(onNext: { [weak self] recipes in
                guard let self = self else { return }
                let isEmpty = recipes.isEmpty
                self.noResultsImageView.isHidden = !isEmpty
                self.noResultsLabel.isHidden = !isEmpty
                self.collectionView.isHidden = isEmpty
            })
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
    
    //    private func setupNoResultsUI() {
    //        if reachability?.connection != .unavailable{
    //            noResultsImageView.image = UIImage(named: "no-results")
    //            noResultsImageView.contentMode = .scaleAspectFit
    //            noResultsImageView.isHidden = true
    //            
    //            noResultsLabel.text = "No elements found"
    //            noResultsLabel.textAlignment = .center
    //            noResultsLabel.textColor = .gray
    //            noResultsLabel.isHidden = true
    //            
    //            view.addSubview(noResultsImageView)
    //            view.addSubview(noResultsLabel)
    //            
    //            noResultsImageView.translatesAutoresizingMaskIntoConstraints = false
    //            noResultsLabel.translatesAutoresizingMaskIntoConstraints = false
    //            
    //            NSLayoutConstraint.activate([
    //                noResultsImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    //                noResultsImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
    //                noResultsImageView.widthAnchor.constraint(equalToConstant: 150),
    //                noResultsImageView.heightAnchor.constraint(equalToConstant: 150),
    //                
    //                noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    //                noResultsLabel.topAnchor.constraint(equalTo: noResultsImageView.bottomAnchor, constant: 10)
    //            ])
    //        }else {
    //            
    //        }
    //    }
    
    private func setupNoInternetUI() {
        
        noInternetImageView.image = UIImage(named: "no-connection")
        noInternetImageView.contentMode = .scaleAspectFit
        noInternetImageView.isHidden = true
        
        noInternetLabel.text = "Check your connectivity"
        noInternetLabel.textAlignment = .center
        noInternetLabel.textColor = .gray
        noInternetLabel.isHidden = true
        
        view.addSubview(noInternetImageView)
        view.addSubview(noInternetLabel)
        
        // Set up constraints
        noInternetImageView.translatesAutoresizingMaskIntoConstraints = false
        noInternetLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noInternetImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noInternetImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            noInternetImageView.widthAnchor.constraint(equalToConstant: 150),
            noInternetImageView.heightAnchor.constraint(equalToConstant: 150),
            
            noInternetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noInternetLabel.topAnchor.constraint(equalTo: noInternetImageView.bottomAnchor, constant: 10)
        ])
    }
    
    private func setupReachability() {
        do {
            reachability = try Reachability()
            
            reachability?.whenReachable = { [weak self] reachability in
                DispatchQueue.main.async {
                    print("Reachable: \(reachability.connection.description)")
                    self?.performSearch()
                }
            }
            
            reachability?.whenUnreachable = { [weak self] reachability in
                DispatchQueue.main.async {
                    print("Unreachable: \(reachability.connection.description)")
                    self?.showNoInternetUI()
                }
            }
            
            try reachability?.startNotifier()
        } catch {
            print("Unable to start reachability notifier")
        }
    }
    
    
    
    
    deinit {
        reachability?.stopNotifier()
    }
    
    
    @IBAction func searchButton(_ sender: Any) {
        lastSearch = recipeSearchBar.text ?? ""
        
        if reachability?.connection != .unavailable {
            performSearch()
        } else {
            showNoInternetUI()
        }
    }
    
    private func performSearch() {
        
        noInternetImageView.isHidden = true
        noInternetLabel.isHidden = true
        collectionView.isHidden = false
        
        viewModel.searchRecipes(query: lastSearch)
        
        resetCategorySelection()
        
        self.collectionView.reloadData()
    }
    
    private func showNoInternetUI() {
        noInternetImageView.isHidden = false
        noInternetLabel.isHidden = false
        collectionView.isHidden = true
    }
    
    
    
    private func resetCategorySelection() {
        
        categoryCollectionView.visibleCells.forEach { cell in
            if let categoryCell = cell as? RecipeCategoryCollectionViewCell {
            }
        }
    }
}
