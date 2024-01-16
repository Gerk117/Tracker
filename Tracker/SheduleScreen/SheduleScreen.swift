//
//  SheduleScreen.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 14.01.2024.
//

import UIKit
import SnapKit

class SheduleScreen : UIViewController {
    var data = [SheduleCellModel(title: "Понедельник"),
                SheduleCellModel(title: "Вторник"),
                SheduleCellModel(title: "Среда"),
                SheduleCellModel(title: "Четверг"),
                SheduleCellModel(title: "Пятница"),
                SheduleCellModel(title: "Суббота"),
                SheduleCellModel(title: "Воскресенье")]
    
    private var table : UITableView = {
        var table = UITableView()
        table.tableHeaderView = UIView()
        table.rowHeight = 75
        table.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        table.separatorColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        return table
    }()
    private var acceptButton : UIButton = {
        var button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.addTarget(self, action: #selector(accept), for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(SheduleCell.self, forCellReuseIdentifier: "cell")
        table.dataSource = self
        table.delegate = self
        setupScreen()
    }
    @objc func accept(){
        navigationController?.popViewController(animated: true)
    }
    private func setupScreen(){
        view.addSubview(table)
        view.addSubview(acceptButton)
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        title = "Расписание"
        table.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(525)
        }
        acceptButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(60)
        }
    }
}

extension SheduleScreen : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SheduleCell
        let model = data[indexPath.row]
        cell?.config(model: model)
        if indexPath.row == 0 {
            cell?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if indexPath.row == data.count - 1 {
            cell?.separatorInset = UIEdgeInsets(top: 0, left: table.frame.width / 2, bottom: 0, right:  table.frame.width / 2)
            cell?.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cell?.layer.cornerRadius = 0
        }
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
