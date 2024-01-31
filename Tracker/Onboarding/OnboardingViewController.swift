//
//  File.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 31.01.2024.
//

import Foundation
import SnapKit
import UIKit

final class OnboardingViewController: UIViewController {
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = TrackerFont.bold34
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private var button : UIButton = {
        let button = UIButton()
        button.setTitle("Вот это технологии", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    func setupViewContent(imageName: String,labelText: String){
        imageView.image = UIImage(named: imageName)
        label.text = labelText
    }
    
    private func setupScreen() {
        view.addSubview(imageView)
        view.addSubview(button)
        view.addSubview(label)
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        imageView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-304)
        }
        button.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-84)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(60)
        }
    }
    
    @objc func tapButton() {
        let bar = MainTabBarScreen()
        UserDefaults.standard.set(true, forKey: "notFirstLaunch")
        bar.modalPresentationStyle = .fullScreen
        present(bar, animated: true)
    }
}
