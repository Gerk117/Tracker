//
//  TrackerViewCellHeader.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 16.01.2024.
//


import UIKit
import SnapKit
final class TrackerViewCellHeader: UICollectionReusableView {
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = TrackerFont.bold19
        label.textAlignment = .left
        return label
    }()
    
    
    func setup(title: String) {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(16)
        }
        label.text = title
    }
}
