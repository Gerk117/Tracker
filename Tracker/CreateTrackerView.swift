//
//  TrackerScreen.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 20.12.2023.
//

import UIKit
import SnapKit


final class CreateTrackerView : UIViewController {
    
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
        screen.regularIventSetup(true)
        screen.delegate = delegate
        navigationController?.pushViewController(screen, animated: true)
    }
    
    @objc func tapIrregularEventButton(){
        let screen = NewHabit()
        screen.delegate = delegate
        screen.regularIventSetup(false)
        navigationController?.pushViewController(screen, animated: true)
    }
    
    func setupScreen(){
        title = "Создание трекера"
        view.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : TrackerFont.medium16 ]
        view.addSubview(habitButton)
        view.addSubview(irregularEventButton)
        habitButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(275)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            
        }
        irregularEventButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.equalTo(habitButton.snp_bottomMargin).offset(16)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            
        }
    }
}
