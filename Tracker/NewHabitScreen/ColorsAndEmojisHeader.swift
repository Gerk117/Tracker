//
//  ColorsAndEmojisHeader.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 23.01.2024.
//

import UIKit
import SnapKit

final class ColorsAndEmojisHeader: UICollectionReusableView {
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = TrackerFont.bold19
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupCell(){
        addSubview(title)
        title.snp.makeConstraints {
            $0.left.equalToSuperview().offset(14)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    func setTitle(_ title : String){
        self.title.text = title
    }
}
