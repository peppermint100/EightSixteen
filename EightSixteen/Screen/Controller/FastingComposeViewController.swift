//
//  NewFastingViewController.swift
//  EightSixteen
//
//  Created by peppermint100 on 2/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class FastingComposeViewController: UIViewController {
    
    var viewModel: FastingComposeViewModel!
    private let disposeBag = DisposeBag()
    private let fastingTimeHours = Array<Int>(1...23)
    private let defaultFastingTime = 16
    
    private var startedAtDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()
    
    private var fastingTimeHoursPicker = UIPickerView()
    
    private var startedAtDatePickerDoneButton = UIBarButtonItem(title: "저장", style: .plain, target: FastingComposeViewController.self, action: nil)
    private var fastingTimeHoursPickerDoneButton = UIBarButtonItem(title: "저장", style: .plain, target: FastingComposeViewController.self, action: nil)
    
    private lazy var startedAtPickerTextField = ESAppPickerTextField<UIDatePicker>(title: "시작", defaultValue: "08:00", picker: startedAtDatePicker)
    private lazy var fastingTimeHoursPickerTextField = ESAppPickerTextField<UIPickerView>(title: "단식 시간", defaultValue: "16", picker: fastingTimeHoursPicker)
    
    private var fastingPeriodLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let startFastingButton = ESAppButton(title: "단식 시작하기")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPickerToolbar()
        bindViewModel()
        setupPicker()
    }
    
    private func bindViewModel() {
        Observable.just(fastingTimeHours)
            .bind(to: fastingTimeHoursPicker.rx.itemTitles) { _, item in
                return "\(item)시간"
            }
            .disposed(by: disposeBag)
        
        startedAtDatePickerDoneButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.fastingTimeHoursPickerTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        fastingTimeHoursPickerDoneButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.fastingTimeHoursPickerTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        let input = FastingComposeViewModel.Input(
            startedAtDate: startedAtDatePicker.rx.date.asObservable(),
            fastingTimeHoursPickerChanged: fastingTimeHoursPicker.rx.itemSelected.asObservable(),
            startFastingButtonTapped: startFastingButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.fastingPeriodText
            .bind(to: fastingPeriodLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.startedAtDateText
            .bind(to: startedAtPickerTextField.valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.fastingTimeHourText
            .bind(to: fastingTimeHoursPickerTextField.valueLabel.rx.text)
            .disposed(by: disposeBag)
    }
        
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(startedAtPickerTextField)
        view.addSubview(fastingTimeHoursPickerTextField)
        view.addSubview(fastingPeriodLabel)
        view.addSubview(startFastingButton)
        
        startedAtPickerTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.height.equalTo(70)
        }
        
        fastingTimeHoursPickerTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(startedAtPickerTextField.snp.bottom).offset(20)
            make.height.equalTo(70)
        }
        
        fastingPeriodLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(fastingTimeHoursPickerTextField.snp.bottom).offset(40)
        }
        
        startFastingButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(60)
        }
    }
    
    private func setupPickerToolbar() {
        let spacing = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let startedAtPickerToolbar = UIToolbar()
        startedAtPickerToolbar.sizeToFit()
        startedAtPickerToolbar.setItems([spacing, startedAtDatePickerDoneButton], animated: true)
        startedAtPickerTextField.inputAccessoryView = startedAtPickerToolbar
        
        let fastingTimeHoursToolbar = UIToolbar()
        fastingTimeHoursToolbar.sizeToFit()
        fastingTimeHoursToolbar.setItems([spacing, fastingTimeHoursPickerDoneButton], animated: true)
        fastingTimeHoursPickerTextField.inputAccessoryView = fastingTimeHoursToolbar
    }
    
    private func setupPicker() {
        fastingTimeHoursPicker.selectRow(15, inComponent: 0, animated: true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if startedAtPickerTextField.isEditing {
            fastingTimeHoursPickerTextField.becomeFirstResponder()
        } else {
            fastingTimeHoursPickerTextField.resignFirstResponder()
        }
    }
}
