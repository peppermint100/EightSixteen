//
//  TodayIndicatorView.swift
//  EightSixteen
//
//  Created by peppermint100 on 2/18/24.
//

import UIKit
import RxSwift

class TodayIndicatorView: UIStackView {
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    private let dayOfWeekLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 26, weight: .semibold)
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        distribution = .fillEqually
        addArrangedSubview(monthLabel)
        addArrangedSubview(dayLabel)
        addArrangedSubview(dayOfWeekLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func bindDate(_ dateObservable: Observable<Date>, disposeBag: DisposeBag) {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        
        dateObservable.map { date in
            let month = calendar.component(.month, from: date)
            return "\(month)"
        }.bind(to: monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        dateObservable.map { date in
            let day = calendar.component(.day, from: date)
            return "\(day)"
        }.bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        dateObservable.map { date in
            let weekDay = calendar.component(.weekday, from: date)
            return "\(dateFormatter.weekdaySymbols[weekDay-1])"
        }.bind(to: dayOfWeekLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
