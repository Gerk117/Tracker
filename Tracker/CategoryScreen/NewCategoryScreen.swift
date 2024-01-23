//
//  NewCategoryScreen.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 19.01.2024.
//

import UIKit
import SnapKit

final class NewCategoryScreen : UIViewController {
    
    weak var delegate : CategoryScreenDelegate?
    
    private var textView : UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        view.layer.cornerRadius = 16
        return view
    }()
    
    private var nameOfNewCategory: UITextField = {
        let textField = UITextField()
        textField.font = TrackerFont.regular17
        textField.placeholder = "Введите название категории"
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = TrackerFont.medium16
        button.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        button.addTarget(self, action: #selector(DoneAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameOfNewCategory.delegate = self
        setupView()
        
    }
    
    @objc private func DoneAction(){
        delegate?.addNewCategory(nameOfCategory: nameOfNewCategory.text!)
        navigationController?.popViewController(animated: true)
    }
    
    func setupView(){
        view.addSubview(textView)
        textView.addSubview(nameOfNewCategory)
        view.addSubview(doneButton)
        view.backgroundColor = .white
        textView.snp.makeConstraints {
            $0.height.equalTo(75)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        nameOfNewCategory.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
        }
        doneButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }
}

extension NewCategoryScreen : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        doneButton.isEnabled = !text.isEmpty
        doneButton.backgroundColor = text.isEmpty ? UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1) : UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneButton.isEnabled = false
        doneButton.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        return true
    }
}
