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

class FastingCountView: UIView {
    
    private var fastingCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray5
        layer.cornerRadius = 12
        clipsToBounds = true
        addSubview(fastingCountLabel)
        fastingCountLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func bindFastingCount(_ fastingCount: Driver<Int>) {
        let disposeBag = DisposeBag()
        fastingCount.map { count in
            return "현재 \(count)일째 단식"
        }.drive(fastingCountLabel.rx.text)
        .disposed(by: disposeBag)
    }
}
