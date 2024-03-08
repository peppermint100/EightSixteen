//
//  RecipeDetailsViewController.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/7/24.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class RecipeDetailsViewController: UIViewController {
    
    var viewModel: RecipeDetailsViewModel!
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let recipeTipLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    private let nutritionView: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.alignment = .center
        sv.backgroundColor = .systemGray4
        sv.layer.cornerRadius = 12
        sv.clipsToBounds = true
        return sv
    }()
    
    private let caloriesNutritionLabelView = NutritionLabelView()
    private let proteinNutritionLabelView = NutritionLabelView()
    private let carbNutritionLabelView = NutritionLabelView()
    private let fatNutritionLabelView = NutritionLabelView()
    
    private let manualView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 10
        return sv
    }()
    
    private let manualStep1View = ManualStepView()
    private let manualStep2View = ManualStepView()
    private let manualStep3View = ManualStepView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(recipeImageView)
        contentView.addSubview(recipeNameLabel)
        
        contentView.addSubview(recipeTipLabel)
        contentView.addSubview(nutritionView)
        contentView.addSubview(manualView)
        
        nutritionView.addArrangedSubview(caloriesNutritionLabelView)
        nutritionView.addArrangedSubview(proteinNutritionLabelView)
        nutritionView.addArrangedSubview(carbNutritionLabelView)
        nutritionView.addArrangedSubview(fatNutritionLabelView)
        
        manualView.addArrangedSubview(manualStep1View)
        manualView.addArrangedSubview(manualStep2View)
        manualView.addArrangedSubview(manualStep3View)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
            make.height.equalTo(scrollView).offset(100)
        }
        
        recipeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        recipeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(recipeImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview()
        }
        
        recipeTipLabel.snp.makeConstraints { make in
            make.top.equalTo(recipeNameLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview()
        }
        
        nutritionView.snp.makeConstraints { make in
            make.top.equalTo(recipeTipLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        manualView.snp.makeConstraints { make in
            make.top.equalTo(nutritionView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(35)
        }
    }
    
    private func bindViewModel() {
        let input = RecipeDetailsViewModel.Input()
        let output = viewModel.transform(input)
        
        output.recipe
            .map { $0.thumbnailUrl.httpsURL() }
            .filter { $0 != nil }
            .subscribe(onNext: { [weak self] url in
                self?.recipeImageView.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
        
        output.recipe
            .map { $0.name }
            .bind(to: recipeNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.recipe
            .map { $0.tip }
            .bind(to: recipeTipLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.recipe
            .subscribe(onNext: { [weak self] recipe in
                self?.caloriesNutritionLabelView.configure(value: recipe.calories, nutritionName: "칼로리")
                self?.proteinNutritionLabelView.configure(value: recipe.protein, nutritionName: "단백질")
                self?.carbNutritionLabelView.configure(value: recipe.carbohydrate, nutritionName: "탄수화물")
                self?.fatNutritionLabelView.configure(value: recipe.fat, nutritionName: "지방")
                
                self?.manualStep1View.configure(desc: recipe.manualDesc01, imageUrl: recipe.manualImage01URL)
                self?.manualStep2View.configure(desc: recipe.manualDesc02, imageUrl: recipe.manualImage02URL)
                self?.manualStep3View.configure(desc: recipe.manualDesc03, imageUrl: recipe.manualImage03URL)
            })
            .disposed(by: disposeBag)
    }
}
