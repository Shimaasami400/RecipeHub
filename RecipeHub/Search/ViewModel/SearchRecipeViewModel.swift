//
//  SearchRecipeViewModel.swift
//  RecipeHub
//
//  Created by Shimaa on 16/08/2024.
//

import Foundation
import RxSwift
import RxRelay

class SearchRecipeViewModel {
    private let networkService: RecipeServiceProtocol
    private let disposeBag = DisposeBag()
    
    let recipes: BehaviorRelay<[Recipe]> = BehaviorRelay(value: [])
    let filteredRecipes: BehaviorRelay<[Recipe]> = BehaviorRelay(value: [])
    let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let errorMessage: PublishSubject<String?> = PublishSubject()
    
    init(networkService: RecipeServiceProtocol = RecipeNetworkService()) {
        self.networkService = networkService
    }
    
    func searchRecipes(query: String) {
        isLoading.accept(true)
        
        networkService.fetchRecipes(query: query) { [weak self] result in
            guard let self = self else { return }
            self.isLoading.accept(false)
            
            switch result {
            case .success(let recipes):
                self.recipes.accept(recipes)
                self.filteredRecipes.accept(recipes)
            case .failure(let error):
                self.errorMessage.onNext(error.localizedDescription)
            }
        }
    }
}

