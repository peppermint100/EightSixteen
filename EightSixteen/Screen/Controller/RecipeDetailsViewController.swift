//
//  RecipeDetailsViewController.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/7/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher

struct RecipeDetailsSection {
    var recipe: Recipe
    var items: [RecipeManual]
}

extension RecipeDetailsSection: SectionModelType {
    init(original: RecipeDetailsSection, items: [RecipeManual]) {
        self = original
        self.recipe = original.recipe
        self.items = items
    }
}

class RecipeDetailsViewController: UIViewController {
    
    var viewModel: RecipeDetailsViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var manualCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.register(ManualCollectionViewCell.self, forCellWithReuseIdentifier: ManualCollectionViewCell.identifier)
        cv.register(RecipeDetailCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RecipeDetailCollectionHeaderView.identifier)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(manualCollectionView)
        
        manualCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        let input = RecipeDetailsViewModel.Input()
        let output = viewModel.transform(input)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<RecipeDetailsSection>(
            configureCell: { dataSource, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManualCollectionViewCell.identifier, for: indexPath)
                        as? ManualCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(desc: item.desc, imageUrl: item.imageUrl)
                return cell
            }
            ,
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RecipeDetailCollectionHeaderView.identifier, for: indexPath)
                        as? RecipeDetailCollectionHeaderView else { return UICollectionReusableView() }
                let recipe = dataSource.sectionModels[indexPath.section].recipe
                cell.configure(
                    imageUrl: recipe.thumbnailUrl,
                    name: recipe.name,
                    tip: recipe.tip,
                    calories: recipe.calories,
                    protein: recipe.protein,
                    carb: recipe.carbohydrate,
                    fat: recipe.fat)
                return cell
            }
        )
        
        output.recipe
            .map { [RecipeDetailsSection(recipe: $0, items: $0.manuals)] }
            .bind(to: manualCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 500)
        layout.itemSize = CGSize(width: view.frame.width, height: 150)
        return layout
    }
}
