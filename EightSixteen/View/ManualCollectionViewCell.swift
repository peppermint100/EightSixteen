//
//  ManualStepView.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/7/24.
//

import UIKit
import SnapKit
import Kingfisher

class ManualCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ManualCollectionViewCell"
    
    private let containerView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    
    private let manualDescLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    private let manualImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)

        containerView.addArrangedSubview(manualDescLabel)
        containerView.addArrangedSubview(manualImageView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(30)
        }
        
        manualImageView.snp.makeConstraints { make in
            make.width.equalTo(containerView.snp.width).multipliedBy(0.4)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func configure(desc: String, imageUrl: String) {
        guard let url = imageUrl.httpsURL() else { return }
        manualDescLabel.text = desc
        manualImageView.kf.setImage(with: url)
    }
}
