//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Давид Бекоев on 28.10.2024.
//


import UIKit

final class TabBarController: UITabBarController {
    
    private let titleTrackers = NSLocalizedString("trackers", comment: "")
    private let titleStatistics = NSLocalizedString("statistics", comment: "")
    private let themeManager: ThemeManager = .shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupTopBar()
    }
    
    private func setupViewControllers() {
        let trackersViewController = UINavigationController(rootViewController: TrackersViewController())
        trackersViewController.tabBarItem = UITabBarItem(
            title: titleTrackers,
            image: UIImage(named: "Tab Logo"),
            selectedImage: nil
        )
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: titleStatistics,
            image: UIImage(named: "Заяц"),
            selectedImage: nil
        )
        
        self.viewControllers = [trackersViewController, statisticsViewController]
    }
    
    private func setupTopBar() {
        tabBar.backgroundColor = .totalWhite
        let topBorder = UIView()
        topBorder.backgroundColor = themeManager.tabBarBorder
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
