//
//  New.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 21.12.2023.
//

import UIKit
import SnapKit


class NewHabit : UIViewController {
    var data : [NewHabitModelOfCell]!
    var regularIvent : Bool!
    
    private lazy var nameOfNewTracker : UITextField = {
        var text = UITextField()
        text.clipsToBounds = true
        text.placeholder = "Введите название трекера"
        return text
    }()
    private var textView : UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        view.layer.cornerRadius = 16
        return view
    }()
    private lazy var cancelButton : UIButton = {
        var button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    private var scrollView = UIScrollView()
    
    private var acceptButton : UIButton = {
        var button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .gray
        return button
    }()
    private var mainStackView : UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    private var buttonStackView : UIStackView = {
        var stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    private lazy var table : UITableView = {
        var table = UITableView()
        table.tableHeaderView = UIView()
        table.rowHeight = 75
        table.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        table.separatorColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(NewHabitCell.self, forCellReuseIdentifier: "NewHabitCell")
        table.dataSource = self
        table.delegate = self
        setupScreen()
    }
    @objc func cancelButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    func setupScreen(){
        if regularIvent {
            title = "Новая привычка"
            data = [NewHabitModelOfCell(title: "Категория"),
                    NewHabitModelOfCell(title: "Расписание")]
        } else{
            title = "Новое нерегулярное событие"
            data = [NewHabitModelOfCell(title: "Категория")]
        }
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(textView)
        textView.addSubview(nameOfNewTracker)
        mainStackView.addArrangedSubview(table)
        mainStackView.addArrangedSubview(buttonStackView)
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(acceptButton)
        scrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        mainStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.width.equalToSuperview().offset(-40)
            make.height.equalToSuperview()
        }
        textView.snp.makeConstraints { make in
            make.height.equalTo(75)
        }
        nameOfNewTracker.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        table.snp.makeConstraints { make in
            if regularIvent {
                make.height.equalTo(150)
            } else {
                make.height.equalTo(75)
            }
        }
        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        
    }
    
}
extension NewHabit : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewHabitCell") as? NewHabitCell
        let model = data[indexPath.row]
        cell?.config(model)
        if indexPath.row == 0 {
            cell?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            if !regularIvent {
                cell?.layer.maskedCorners = [.layerMinXMaxYCorner,
                                             .layerMaxXMaxYCorner,
                                             .layerMaxXMinYCorner,
                                             .layerMinXMinYCorner]
                cell?.separatorInset = UIEdgeInsets(top: 0, left: table.frame.width / 2, bottom: 0, right:  table.frame.width / 2)
                return cell ?? UITableViewCell()
            }
        }else if indexPath.row == data.count - 1 {
            cell?.separatorInset = UIEdgeInsets(top: 0, left: table.frame.width / 2, bottom: 0, right:  table.frame.width / 2)
            cell?.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cell?.layer.cornerRadius = 0
        }
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            navigationController?.pushViewController(SheduleScreen(), animated: true)
        }
        
    }
    
    
}
