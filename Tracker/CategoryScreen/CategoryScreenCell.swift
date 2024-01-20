//
//  CategoryScreenCell.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 18.01.2024.
//

import UIKit
import SnapKit

class CategoryScreenCell : UITableViewCell {
    private var nameOfCategory : UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = TrackerFont.regular17
        return label
    }()
    func config(categoryName: String){
        layer.cornerRadius = 16
        clipsToBounds = true
        backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        contentView.addSubview(nameOfCategory)
        nameOfCategory.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        nameOfCategory.text = categoryName
    }
    func retunName()->String? {
        nameOfCategory.text
    }
}
