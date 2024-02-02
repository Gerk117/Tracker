//
//  ViewController.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 05.12.2023.
//

import UIKit

class MainTabBarScreen: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    private func setupScreen(){
        let trackerScreen = UINavigationController(rootViewController: TrackersViewController())
        trackerScreen.tabBarItem.image = UIImage(named: "tracker")
        let statisticScreen = StatisticScreen()
        statisticScreen.tabBarItem.title = NSLocalizedString("Статистика", comment: "")
        statisticScreen.tabBarItem.image = UIImage(named: "statistic")
        addChild(trackerScreen)
        addChild(statisticScreen)
        view.backgroundColor = UIColor(named: "White")
        let line = UIView(frame: CGRect(x: 0 , y: 0, width: tabBar.frame.width, height: 0.5))
        line.backgroundColor = .gray
        tabBar.addSubview(line)
    }
}

