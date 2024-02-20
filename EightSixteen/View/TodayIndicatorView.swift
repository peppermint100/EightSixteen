//
//  TodayIndicatorView.swift
//  EightSixteen
//
//  Created by peppermint100 on 2/18/24.
//

import UIKit
import RxSwift

class TodayIndicatorView: UIStackView {
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    
    var today: Date? {
        didSet {
            guard let today = today else { return }
            let month = calendar.component(.month, from: today)
            let day = calendar.component(.day, from: today)
            let weekDay = calendar.component(.weekday, from: today)
            monthLabel.text = "\(month)"
            dayLabel.text = "\(day)"
            dayOfWeekLabel.text = "\(dateFormatter.weekdaySymbols[weekDay-1])"
        }
    }
    
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
}
