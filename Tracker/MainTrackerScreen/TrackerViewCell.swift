//
//  TrackerViewCell.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 16.01.2024.
//

import UIKit
import SnapKit

class TrackerViewCell : UICollectionViewCell {
    var color : UIColor!
    var id : Int!
    var completed : Bool!
    
    private var view : UIView = {
        var view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    private let emoji : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = TrackerFont.medium16
        label.backgroundColor = .white.withAlphaComponent(0.3)
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        return label
    }()
    
    private let TrackerName : UILabel = {
        let label = UILabel()
        label.font = TrackerFont.medium12
        label.textColor = .white
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    private let completedDays : UILabel = {
        let label = UILabel()
        label.font = TrackerFont.medium12
        label.text = "7 дней"
        return label
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 17
        button.setImage(UIImage(named: "AddTracker"), for: .normal)
        button.clipsToBounds = true
        button.contentMode = .center
        return button
    }()
    func setupCell(){
        addSubview(view)
        addSubview(completeButton)
        addSubview(completedDays)
        view.addSubview(emoji)
        view.addSubview(TrackerName)
        view.snp.makeConstraints { make in
            make.height.equalTo(90)
            make.width.equalTo(167)
            make.left.top.equalToSuperview()
        }
        emoji.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.left.top.equalToSuperview().offset(12)
        }
        TrackerName.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-12)
        }
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp_bottomMargin).offset(16)
            make.right.equalToSuperview().offset(-12)
            make.height.width.equalTo(34)
        }
        completedDays.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(view.snp_bottomMargin).offset(24)
            make.right.equalTo(completeButton.snp_leftMargin).offset(-8)
        }
        
    }
    func config(model : TrackerModel){
        setupCell()
        emoji.text = "❤️"
        TrackerName.text = model.name
        view.backgroundColor = model.colorName
        completeButton.backgroundColor = model.colorName
    }
}
