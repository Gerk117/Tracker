//
//  File.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 02.02.2024.
//

import UIKit
import SnapKit

final class StatiscticLabel : UIView {
    
    private lazy var layerLine: UIView = {
        let innerRect = UIView()
        innerRect.backgroundColor = UIColor(named: "White")
        innerRect.clipsToBounds = true
        innerRect.layer.cornerRadius = 15
        innerRect.backgroundColor = .white
        return innerRect
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = TrackerFont.bold34
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .left
        return label
    }()
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = TrackerFont.medium12
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupScreen()
    }
    
    func setupView(number: String, name: String) {
        countLabel.text = number
        textLabel.text = name
    }
    
    private func setupScreen() {
        clipsToBounds = true
        layer.cornerRadius = 16
        
        addSubview(layerLine)
        layerLine.addSubview(countLabel)
        layerLine.addSubview(textLabel)
        setGradient()
        layerLine.snp.makeConstraints {
            $0.left.top.equalToSuperview().offset(1)
            $0.right.bottom.equalToSuperview().offset(-1)
        }
        countLabel.snp.makeConstraints {
            $0.left.top.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-12)
        }
        textLabel.snp.makeConstraints {
            $0.top.equalTo(countLabel.snp_bottomMargin).offset(8)
            $0.left.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-12)
            $0.right.equalToSuperview().offset(-12)
        }
        
    }
    
    private func setGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(named: "ColorSelection1")!.cgColor,
                                UIColor(named: "ColorSelection9")!.cgColor,
                                UIColor(named: "ColorSelection3")!.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
