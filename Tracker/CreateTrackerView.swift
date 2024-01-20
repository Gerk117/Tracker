//
//  TrackerScreen.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 20.12.2023.
//

import UIKit
import SnapKit


class CreateTrackerView : UIViewController {
    
    weak var delegate : TrackersViewDelegate?
    
    private lazy var habitButton : UIButton = {
        var button = UIButton()
        button.setTitle("Привычка", for: .normal)
        button.backgroundColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
        button.titleLabel?.font = TrackerFont.medium16
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(tapHabitButtonAction), for: .touchUpInside)
        return button
    }()
    private lazy var irregularEventButton : UIButton = {
        var button = UIButton()
        button.setTitle("Нерегулярное событие", for: .normal)
        button.backgroundColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
        button.titleLabel?.font = TrackerFont.medium16
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(tapIrregularEventButton), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    @objc func tapHabitButtonAction(){
        let screen = NewHabit()
        screen.regularIvent = true
        screen.delegate = delegate
        navigationController?.pushViewController(screen, animated: true)
    }
    @objc func tapIrregularEventButton(){
        let screen = NewHabit()
        screen.delegate = delegate
        screen.regularIvent = false
        navigationController?.pushViewController(screen, animated: true)
    }
    func setupScreen(){
        title = "создание трекера"
        view.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : TrackerFont.medium16 ]
        view.addSubview(habitButton)
        view.addSubview(irregularEventButton)
        habitButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(275)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            
        }
        irregularEventButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.top.equalTo(habitButton.snp_bottomMargin).offset(16)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            
        }
    }
}
