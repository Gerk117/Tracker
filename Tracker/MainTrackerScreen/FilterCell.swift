//
//  FilterCell.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 02.02.2024.
//

import UIKit
import SnapKit

final class FilterCell : UITableViewCell {
    
    private var titleLable : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(text : String) {
        titleLable.text = text
        setupScreen()
    }
    
    private func setupScreen(){
        clipsToBounds = true
        backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        contentView.addSubview(titleLable)
        titleLable.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
        }
    }
}
