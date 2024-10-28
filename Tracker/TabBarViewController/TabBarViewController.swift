//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Давид Бекоев on 28.10.2024.
//

import UIKit
class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackerNavigationController = TrackersNavigationController()
        let statisticsNavigationController = StatisticsNavigationsController()
        
        trackerNavigationController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "Tab Logo"),
            selectedImage: nil
        )
        statisticsNavigationController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "Заяц"),
            selectedImage: nil
        )
        
        self.viewControllers = [trackerNavigationController, statisticsNavigationController]
    }
}
