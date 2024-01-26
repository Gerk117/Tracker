//
//  SheduleCell.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 14.01.2024.
//

import UIKit
import SnapKit

final class SheduleCell : UITableViewCell {
    
    private var label : UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = TrackerFont.regular17
        return label
    }()
    
    private var switchButton : UISwitch = {
        var button = UISwitch()
        button.onTintColor = UIColor(red: 55/255, green: 114/255, blue: 231/255, alpha: 1)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScreen(){
        contentView.addSubview(label)
        contentView.addSubview(switchButton)
        layer.cornerRadius = 16
        clipsToBounds = true
        accessoryView = switchButton
        backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        switchButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    func config(title : String){
        label.text = title
        setupScreen()
    }
}
