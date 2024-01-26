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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(label)
        label.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-12)
            $0.top.equalToSuperview().offset(16)
        }
    }
    func update(title : String) {
        label.text = title
    }
}
