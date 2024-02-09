//
//  FilterViewController.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 02.02.2024.
//


import UIKit
import SnapKit

final class FilterViewController: UIViewController {
    
    weak var delegate: FilterViewDelegate?
    var currentFilter: String?
    
    var data = [NSLocalizedString("Все трекеры", comment: ""),
                NSLocalizedString("Трекеры на сегодня", comment: ""),
                NSLocalizedString("Завершенные", comment: ""),
                NSLocalizedString("Не завершенные", comment: "")]
    
    private let titleView: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = TrackerFont.medium16
        label.text = NSLocalizedString("Filters", comment: "")
        return label
    }()
    
    private var table : UITableView = {
        let table = UITableView()
        table.register(FilterCell.self, forCellReuseIdentifier: "cell")
        table.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        table.clipsToBounds = true
        table.rowHeight = 75
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        setupScreen()
    }
    
    func setCurrentFilter(_ name : String){
        currentFilter = name
    }
    
    private func setupScreen() {
        view.backgroundColor = UIColor.white
        view.addSubview(titleView)
        view.addSubview(table)
        
        titleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.height.equalTo(22)
            $0.centerX.equalToSuperview()
        }
        table.snp.makeConstraints {
            $0.top.equalTo(titleView.snp_bottomMargin).offset(24)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-100)
        }
    }
}

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? FilterCell
        cell?.config(text: data[indexPath.row])
        
        if indexPath.row == 0 {
            cell?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        if indexPath.row == 3 {
            cell?.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell?.separatorInset = UIEdgeInsets(top: 0, left: table.frame.width / 2, bottom: 0, right: table.frame.width / 2)
        }
        
        if currentFilter == data[indexPath.row] {
            cell?.accessoryType = .checkmark
        }
        return cell ?? UITableViewCell()
    }
    
    
}

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        self.dismiss(animated: true)
        if currentFilter == data[indexPath.row] {
            currentFilter = NSLocalizedString("Все трекеры", comment: "")
            delegate?.didDeselectFilter()
        } else {
            currentFilter = data[indexPath.row]
            delegate?.didSelectFilter(data[indexPath.row])
        }
        
    }
}
