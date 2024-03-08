//
//  NutritionLabelView.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/7/24.
//

import UIKit
import SnapKit

class NutritionLabelView: UIStackView {
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let nutritionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        distribution = .fillEqually
        addArrangedSubview(valueLabel)
        addArrangedSubview(nutritionNameLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func configure(value: String, nutritionName: String) {
        valueLabel.text = value
        nutritionNameLabel.text = nutritionName
    }
}
