//
//  NewHabitCell.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 25.12.2023.
//

import UIKit
import SnapKit

class NewHabitCell : UITableViewCell {
   private var title : UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = TrackerFont.regular17
        return label
    }()
    private var button : UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "chevron"), for: .normal)
        return button
    }()
    func setupCell(){
        contentView.addSubview(title)
        contentView.addSubview(button)
        layer.cornerRadius = 16
        clipsToBounds = true
        backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(button.snp_leftMargin)
        }
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(24)
            make.right.equalToSuperview().offset(-20)
        }
    }
    func config(_ model : NewHabitModelOfCell){
        setupCell()
        title.text = model.title
    }
}

