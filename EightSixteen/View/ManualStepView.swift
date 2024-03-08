//
//  ManualStepView.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/7/24.
//

import UIKit
import SnapKit
import Kingfisher

class ManualStepView: UIStackView {
    
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
        axis = .horizontal
        distribution = .fill
        
        addArrangedSubview(manualDescLabel)
        addArrangedSubview(manualImageView)
        
        manualImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.4)
            make.top.bottom.equalToSuperview()
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
