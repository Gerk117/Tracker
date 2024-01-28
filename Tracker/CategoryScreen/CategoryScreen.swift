//
//  CategoryScreen.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 18.01.2024.
//

import UIKit
import SnapKit

protocol CategoryScreenDelegate : AnyObject{
    func addNewCategory(nameOfCategory:String)
}

final class CategoryScreen : UIViewController {
    
    weak var delegate : NewHabitCategoryDelegate?
    
    private var dataCategory = ["lol"]
    
    private var infoLabel : UILabel = {
        var label = UILabel()
        label.font = TrackerFont.medium12
        label.textColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Привычки и события\nможно объединить по смыслу"
        return label
    }()
    
    private var imageView : UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "star")
        return image
    }()
    
    private lazy var addCategoryButton : UIButton = {
        var button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.backgroundColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
        button.titleLabel?.font = TrackerFont.medium16
        button.layer.cornerRadius = 16
        button.addTarget(self , action: #selector(addCategory), for: .touchUpInside)
        return button
    }()
    
    private var table : UITableView = {
        var table = UITableView()
        table.tableHeaderView = UIView()
        table.separatorColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        table.rowHeight = 75
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        table.register(CategoryScreenCell.self, forCellReuseIdentifier: "cell")
        setupScreen()
    }
    
    @objc  private func addCategory(){
        let view = NewCategoryScreen()
        view.delegate = self
        navigationController?.pushViewController(view, animated: true)
    }
    
    func setupScreen(){
        view.backgroundColor = .white
        title = "Категория"
        view.addSubview(table)
        view.addSubview(imageView)
        view.addSubview(infoLabel)
        view.addSubview(addCategoryButton)
        addCategoryButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-29)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(60)
        }
        imageView.snp.makeConstraints {
            $0.height.width.equalTo(80)
            $0.centerX.centerY.equalToSuperview()
        }
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp_bottomMargin).offset(8)
            $0.centerX.equalToSuperview()
        }
        table.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalTo(addCategoryButton.snp_topMargin)
        }
        if dataCategory.isEmpty {
            table.isHidden = true
        } else {
            infoLabel.isHidden = true
            imageView.isHidden = true
        }
    }
}
extension CategoryScreen : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CategoryScreenCell
        cell?.config(categoryName: dataCategory[indexPath.row])
        if indexPath.row == 0 {
            if dataCategory.count == 1 {
                cell?.layer.maskedCorners = [.layerMinXMinYCorner,
                                             .layerMaxXMinYCorner,
                                             .layerMinXMaxYCorner,
                                             .layerMaxXMaxYCorner]
                cell?.separatorInset = UIEdgeInsets(top: 0, left: table.frame.width / 2, bottom: 0, right: table.frame.width / 2)
                return cell ?? UITableViewCell()
            }
            cell?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell?.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        } else if indexPath.row == dataCategory.count - 1 {
            cell?.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell?.separatorInset = UIEdgeInsets(top: 0, left: table.frame.width / 2, bottom: 0, right: table.frame.width / 2)
        } else {
            cell?.layer.cornerRadius = 0
            cell?.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as? CategoryScreenCell
        if let title = cell?.retunName() {
            delegate?.category(titleForCategory: title)
        }
        navigationController?.popViewController(animated: true)
    }
}

extension CategoryScreen : CategoryScreenDelegate {
    func addNewCategory(nameOfCategory: String) {
        dataCategory.append(nameOfCategory)
        table.reloadData()
    }
}
