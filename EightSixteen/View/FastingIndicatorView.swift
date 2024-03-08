//
//  FastingCountView.swift
//  EightSixteen
//
//  Created by peppermint100 on 2/18/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class FastingIndicatorView: UIStackView {
    
    var fastingStartedAtLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    var fastingEndedAtLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray5
        layer.cornerRadius = 12
        clipsToBounds = true
        axis = .vertical
        alignment = .center
        distribution = .fillEqually
        spacing = 8
        addArrangedSubview(fastingStartedAtLabel)
        addArrangedSubview(fastingEndedAtLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}
