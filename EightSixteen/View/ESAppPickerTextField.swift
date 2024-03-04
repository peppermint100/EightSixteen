//
//  ESAppPickerTextField.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/1/24.
//

import UIKit

protocol PickerType: UIView {}

class ESAppPickerTextField<T: PickerType>: UITextField {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        return label
    }()
    
    var valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        return label
    }()
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String, defaultValue: String, picker: T) {
        self.init(frame: .zero)
        setupUI()
        titleLabel.text = title
        valueLabel.text = defaultValue
        inputView = picker
    }
    
    private func setupUI() {
        backgroundColor = .systemGray5
        layer.cornerRadius = 12
        clipsToBounds = true
        tintColor = .clear
        isSecureTextEntry = true
        
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }
    
    override func buildMenu(with builder: UIMenuBuilder) {
        if #available(iOS 17.0, *) {
            builder.remove(menu: .autoFill)
        }
        super.buildMenu(with: builder)
    }
}
