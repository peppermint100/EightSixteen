//
//  RecipeDetailTableHeaderView.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/9/24.
//

import UIKit
import SnapKit
import Kingfisher

class RecipeDetailCollectionHeaderView: UICollectionReusableView {
    
    static let identifier = "RecipeDetailCollectionHeaderView"
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI(){
        addSubview(recipeImageView)
        addSubview(recipeNameLabel)
        
        addSubview(recipeTipLabel)
        addSubview(nutritionView)
        
        nutritionView.addArrangedSubview(caloriesNutritionLabelView)
        nutritionView.addArrangedSubview(proteinNutritionLabelView)
        nutritionView.addArrangedSubview(carbNutritionLabelView)
        nutritionView.addArrangedSubview(fatNutritionLabelView)
        
        recipeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        recipeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(recipeImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        recipeTipLabel.snp.makeConstraints { make in
            make.top.equalTo(recipeNameLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        nutritionView.snp.makeConstraints { make in
            make.top.equalTo(recipeTipLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func configure(
        imageUrl: String, name: String, tip: String, calories: String, protein: String, carb: String, fat: String
    ) {
        recipeImageView.kf.setImage(with: imageUrl.httpsURL())
        recipeNameLabel.text = name
        recipeTipLabel.text = tip
        caloriesNutritionLabelView.configure(value: calories, nutritionName: "칼로리")
        proteinNutritionLabelView.configure(value: protein, nutritionName: "단백질")
        carbNutritionLabelView.configure(value: carb, nutritionName: "탄수화물")
        fatNutritionLabelView.configure(value: fat, nutritionName: "지방")
    }
}
