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
    private var subtitle : UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        label.font = TrackerFont.regular17
        return label
    }()
    
    func setupCell(){
        contentView.addSubview(title)
        contentView.addSubview(subtitle)
        layer.cornerRadius = 16
        clipsToBounds = true
        backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        
    }
    func setupView(){
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    func setupFullView(){
        title.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        subtitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp_bottomMargin).offset(2)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-14)
        }
        
    }
    func config(nameOfCell : String){
        setupCell()
        setupView()
        subtitle.isHidden = true
        title.text = nameOfCell
    }
    
    func setupSubTitle(title:String){
        setupCell()
        setupFullView()
        subtitle.isHidden = false
        subtitle.text = title
    }
    
}

