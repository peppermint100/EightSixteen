//
//  ESAppButton.swift
//  EightSixteen
//
//  Created by peppermint100 on 2/29/24.
//

import UIKit

class ESAppButton: UIButton {
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(
        title: String, bgColor: UIColor = .systemBlue,
        fontSize: CGFloat = 18, weight: UIFont.Weight = .semibold) {
        self.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: fontSize, weight: weight)
        backgroundColor = bgColor
        layer.cornerRadius = 12
        clipsToBounds = true
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}
