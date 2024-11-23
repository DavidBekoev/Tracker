//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Давид Бекоев on 28.10.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupTopBar()
    }
    
    private func setupViewControllers() {
        let trackersViewController = UINavigationController(rootViewController: TrackerViewController())
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "Tab Logo"),
            selectedImage: nil
        )
        
        let statisticsViewController = StatisticsController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "Заяц"),
            selectedImage: nil
        )
        
        self.viewControllers = [trackersViewController, statisticsViewController]
    }
    
    private func setupTopBar() {
        tabBar.backgroundColor = .white
        let topBorder = UIView()
        topBorder.backgroundColor = .gray
        topBorder.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBorder)
        
        NSLayoutConstraint.activate([
            topBorder.heightAnchor.constraint(equalToConstant: 1),
            topBorder.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            topBorder.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            topBorder.bottomAnchor.constraint(equalTo: tabBar.topAnchor)
        ])
    }
}
