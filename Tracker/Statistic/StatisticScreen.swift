//
//  StatisticScreen.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 06.12.2023.
//

import UIKit
import SnapKit

final class StatisticScreen : UIViewController {
    
    private let recordStore = TrackerRecordStore.shared
    
    private let statImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cryEmoji")
        return imageView
    }()
    
    private let statLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("There is nothing to analyze", comment: "")
        label.font = TrackerFont.medium12
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .center
        return label
    }()
    
    private let bestPeriod = StatiscticLabel()
    
    private let perfectDaysLabel = StatiscticLabel()
    
    private let completedLabel = StatiscticLabel()
    
    private let averageLabel = StatiscticLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
    }
    
    private func setupScreen() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = NSLocalizedString("Статистика", comment: "")
        [statImageView,
         statLabel,
         bestPeriod,
         perfectDaysLabel,
         completedLabel,
         averageLabel].forEach {
            view.addSubview($0)
        }
        statImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.width.equalTo(80)
        }
        statLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(statImageView.snp_bottomMargin).offset(8)
        }
        bestPeriod.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-12)
            $0.top.equalToSuperview().offset(206)
        }
        perfectDaysLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-12)
            $0.top.equalTo(bestPeriod.snp_bottomMargin).offset(18)
        }
        completedLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-12)
            $0.top.equalTo(perfectDaysLabel.snp_bottomMargin).offset(18)
        }
        averageLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-12)
            $0.top.equalTo(completedLabel.snp_bottomMargin).offset(18)
        }
    }
    
    private func setupData(){
        if recordStore.numberOfCompleted() == 0 {
            statImageView.isHidden = false
            statLabel.isHidden = false
            [bestPeriod,
             perfectDaysLabel,
             completedLabel,
             averageLabel].forEach {
                $0.isHidden = true
            }
        } else {
            statImageView.isHidden = true
            statLabel.isHidden = true
            [bestPeriod,
             perfectDaysLabel,
             completedLabel,
             averageLabel].forEach {
                $0.isHidden = false
            }
            completedLabel.setupView(number: "\(recordStore.numberOfCompleted())",
                                     name: NSLocalizedString("Трекеров завершено", comment: ""))
            perfectDaysLabel.setupView(number: "\(recordStore.bestDay())",
                                       name: NSLocalizedString("Идеальные дни", comment: ""))
            bestPeriod.setupView(number: "\(recordStore.maximumNumberOfExecutedDays())",
                                 name:  NSLocalizedString("Лучший период", comment: ""))
            averageLabel.setupView(number: "\(recordStore.averageValueOfCompletedTrackers())",
                                   name: NSLocalizedString("Среднее значение", comment: ""))
        }
    }
}
