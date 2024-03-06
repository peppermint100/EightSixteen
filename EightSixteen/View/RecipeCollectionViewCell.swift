//
//  RecipeCollectionViewCell.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/6/24.
//

import UIKit
import SnapKit
import Kingfisher

class RecipeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RecipeCollectionViewCell"
    
    private let containerView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 5
        sv.distribution = .fill
        return sv
    }()
    
    private let recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .systemGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addArrangedSubview(recipeImageView)
        containerView.addArrangedSubview(recipeNameLabel)
        containerView.addArrangedSubview(categoryLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        recipeImageView.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
    }
    
    func configure(imageUrl: URL?, name: String, category: String) {
        if let imageUrl = imageUrl {
            recipeImageView.kf.setImage(with: imageUrl)
        } else {
            recipeImageView.contentMode = .scaleAspectFit
            recipeImageView.image = UIImage(systemName: "fork.knife")
        }
        recipeNameLabel.text = name
        categoryLabel.text = category
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}
