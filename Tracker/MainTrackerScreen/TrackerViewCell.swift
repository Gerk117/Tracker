//
//  TrackerViewCell.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 16.01.2024.
//

import UIKit
import SnapKit

final class TrackerViewCell : UICollectionViewCell {
    
    var color : UIColor!
    
    var id : UUID!
    
    var completed : Bool!
    
    var date : Date!
    
    weak var delegate : TrackerViewCellDelegate?
    
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
        return label
    }()
    
    private var completeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 17
        button.clipsToBounds = true
        button.contentMode = .center
        button.tintColor = .white
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tap(){
        
        guard date <= Date() else {
            return
        }
        
        let trackerRecord = TrackerRecord(id: id, date: date)
        if completed {
            delegate?.uncompleteTracker(trackerRecord)
            completeButton.setImage(UIImage(systemName: "plus"), for: .normal)
            completeButton.alpha = 1
        }else{
            delegate?.completeTraker(trackerRecord)
            completeButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            completeButton.alpha = 0.3
        }
    }
    private func correctDays(_ count: Int) {
        var days: String
        if count % 10 == 1 && count % 100 != 11 {
            days = "день"
        } else if count % 10 >= 2 && count % 10 <= 4 && (count % 100 < 10 || count % 100 >= 20) {
            days = "дня"
        } else {
            days = "дней"
        }
        completedDays.text = "\(count) \(days)"
    }
    private func setupConstrains(){
        view.snp.makeConstraints {
            $0.height.equalTo(90)
            $0.width.equalTo(167)
            $0.left.top.equalToSuperview()
        }
        emoji.snp.makeConstraints {
            $0.height.width.equalTo(24)
            $0.left.top.equalToSuperview().offset(12)
        }
        TrackerName.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-12)
            $0.bottom.equalToSuperview().offset(-12)
        }
        completeButton.snp.makeConstraints {
            $0.top.equalTo(view.snp_bottomMargin).offset(16)
            $0.right.equalToSuperview().offset(-12)
            $0.height.width.equalTo(34)
        }
        completedDays.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.top.equalTo(view.snp_bottomMargin).offset(24)
            $0.right.equalTo(completeButton.snp_leftMargin).offset(-8)}
    }
    private func setupCell(){
        contentView.addSubview(view)
        contentView.addSubview(completeButton)
        contentView.addSubview(completedDays)
        view.addSubview(emoji)
        view.addSubview(TrackerName)
    }
    
    func config(model : TrackerModel, completedCount : Int, completedToday : Bool){
        completed = completedToday
        id = model.id
        emoji.text = model.emoji
        TrackerName.text = model.name
        view.backgroundColor = model.colorName
        completeButton.backgroundColor = model.colorName
        correctDays(completedCount)
        if completed {
            completeButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            completeButton.alpha = 0.3
        } else {
            completeButton.setImage(UIImage(systemName: "plus"), for: .normal)
            completeButton.alpha = 1
        }
    }
}
