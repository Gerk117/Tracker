//
//  File.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 23.01.2024.
//

import UIKit
import SnapKit

final class ColorsAndEmojisCell: UICollectionViewCell {
    
    private var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .center
        title.layer.cornerRadius = 8
        title.clipsToBounds = true
        title.font = TrackerFont.bold32
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell(){
        contentView.addSubview(titleLabel)
        layer.borderColor = UIColor.white.cgColor
        titleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(6)
            $0.right.bottom.equalToSuperview().offset(-6)
        }
    }
    
    func config(_ emoji: String?, _ color : UIColor?) {
        titleLabel.text = emoji
        guard let color else {
            return
        }
        titleLabel.backgroundColor = color
    }
}
