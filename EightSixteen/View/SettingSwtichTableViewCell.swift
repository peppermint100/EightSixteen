//
//  SettingSwtichTableViewCell.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/8/24.
//

import UIKit
import SnapKit

protocol SettingSwitchTableViewCellDelegate: AnyObject {
    func toggle(_ next: Bool)
}

class SettingSwtichTableViewCell: UITableViewCell {
    
    static let identifier = "SettingSwtichTableViewCell"
    
    var delegate: SettingSwitchTableViewCellDelegate?
    
    private let iconContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .white
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let toggleSwitch: UISwitch = {
        let ts = UISwitch()
        return ts
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(toggleSwitch)
        
        iconContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconView.snp.trailing).offset(15)
        }
        
        toggleSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func configure(image: UIImage, backgroundColor: UIColor, title: String, isActive: Bool) {
        iconContainer.backgroundColor = backgroundColor
        iconView.image = image
        titleLabel.text = title
        toggleSwitch.isOn = isActive
        toggleSwitch.addTarget(self, action: #selector(onToggleSwitch(_:)), for: .valueChanged)
    }
    
    @objc private func onToggleSwitch(_ sender: UISwitch) {
        let next = sender.isOn
        delegate?.toggle(next)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}
