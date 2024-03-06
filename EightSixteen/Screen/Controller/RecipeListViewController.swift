//
//  RecipeListViewController.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/6/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RecipeListViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var viewModel: RecipeListViewModel!
    private lazy var recipeCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        cv.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: RecipeCollectionViewCell.identifier)
        return cv
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = false
        indicator.style = .large
        indicator.startAnimating()
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(loadingIndicator)
        view.addSubview(recipeCollectionView)
        
        recipeCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindViewModel() {
        let input = RecipeListViewModel.Input()
        let output = viewModel.transform(input)
        
        output.navigationTitle
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        output.recipes
            .bind(to: recipeCollectionView.rx.items(cellIdentifier: RecipeCollectionViewCell.identifier, cellType: RecipeCollectionViewCell.self)) {
                idx, recipe, cell in
                cell.configure(imageUrl: recipe.httpsThumbnailUrl, name: recipe.name, category: recipe.category)
            }
            .disposed(by: disposeBag)
        
        output.isFetchingRecipes
            .bind(to: recipeCollectionView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isFetchingRecipes
            .map { !$0 }
            .bind(to: loadingIndicator.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isFetchingRecipes
            .subscribe(onNext: { [weak self] isFetching in
                if isFetching { self?.loadingIndicator.startAnimating() }
                else { self?.loadingIndicator.stopAnimating() }
            })
            .disposed(by: disposeBag)
    }
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let inset: CGFloat = 15
        let itemWidth = (view.frame.width / 2) - (inset * 1.5)
        let itemHeight: CGFloat = 210
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        return layout
    }
}
