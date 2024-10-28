//
//  StatisticNavigationController.swift
//  Tracker
//
//  Created by Давид Бекоев on 28.10.2024.
//

import UIKit
final class StatisticsNavigationsController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = StatisticsController()
        pushViewController(view, animated: true)
    }
}
