//
//  TrackerViewCell.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 16.01.2024.
//

import UIKit
import SnapKit

final class TrackerViewCell : UICollectionViewCell {
    
    var date : Date!
    
    private var color : UIColor!
    
    private var id : UUID!
    
    private var completed : Bool!
    
    private var isPinnde = false
    
    
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
    
    private let pinIcon: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "pin.fill"))
        image.tintColor = .white
        image.isHidden = true
        return image
    }()
    
    private lazy var completeButton: UIButton = {
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
        view.addInteraction(UIContextMenuInteraction(delegate: self))
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
            days = NSLocalizedString("день", comment: "")
        } else if count % 10 >= 2 && count % 10 <= 4 && (count % 100 < 10 || count % 100 >= 20) {
            days = NSLocalizedString("дня", comment: "")
        } else {
            days = NSLocalizedString("дней", comment: "")
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
        pinIcon.snp.makeConstraints {
            $0.height.width.equalTo(12) // знаю что не по макету, но если ставлю 24 то выглядит больше чем на макете.
            $0.top.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-4)
        }
    }
    private func setupCell(){
        contentView.addSubview(view)
        contentView.addSubview(completeButton)
        contentView.addSubview(completedDays)
        contentView.addSubview(pinIcon)
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
        isPinnde = model.isPinned
        if completed {
            completeButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            completeButton.alpha = 0.3
        } else {
            completeButton.setImage(UIImage(systemName: "plus"), for: .normal)
            completeButton.alpha = 1
        }
        pinIcon.isHidden = !self.isPinnde
    }
}

extension TrackerViewCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            suggestedActions in
            
            //            self.analyticsService.reportEvent(event: "Did tap tracker cell", parameters: ["event": "click", "screen": "Main", "item": "cell"])
            //
            let pinAction = UIAction(title: self.isPinnde ?
                                     NSLocalizedString("Открепить", comment: "") :
                                        NSLocalizedString("Закрепить", comment: "")) { action in
                if self.isPinnde {
                    self.delegate?.unPinTracker(self.id)
                } else {
                    self.delegate?.pinTracker(self.id)
                }
                self.pinIcon.isHidden = !self.isPinnde
            }
            
            let editAction = UIAction(title: NSLocalizedString("Edit", comment: "")) { action in
                self.delegate?.changeTracker(self.id)
            }
            
            let deleteAction = UIAction(title: NSLocalizedString("Delete", comment: ""), attributes: .destructive) { action in
                self.delegate?.deleteTracker(self.id)
            }
            
            return UIMenu(title: "", children: [pinAction, editAction, deleteAction])
        })
    }
}

