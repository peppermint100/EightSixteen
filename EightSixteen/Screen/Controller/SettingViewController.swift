//
//  SettingViewController.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class SettingViewController: UIViewController {
    
    private let presenter = SettingViewPresenter()
    private let disposeBag = DisposeBag()
    
    private let settingTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
        setupTableView()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(settingTableView)
       
        settingTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavigation() {
        navigationItem.title = presenter.navigationTitle()
    }
    
    @objc private func check() {
        print(presenter.getAllowNotificationSetting())
    }
    
    private func setupTableView() {
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.register(SettingSwtichTableViewCell.self, forCellReuseIdentifier: SettingSwtichTableViewCell.identifier)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.titleForHeaderInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = presenter.getSettingOption(section: indexPath.section, row: indexPath.row)
        
        switch option {
        case .switchType(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingSwtichTableViewCell.identifier)
                    as? SettingSwtichTableViewCell else { return UITableViewCell() }
            cell.configure(image: model.icon, backgroundColor: model.iconBackgroundColor, title: model.title, isActive: model.isActive)
            cell.delegate = self
            return cell
        }
    }
}

extension SettingViewController: SettingSwitchTableViewCellDelegate {
    func toggle(_ next: Bool) {
        presenter.toggleAllowNotificationSetting(next)
    }
}
