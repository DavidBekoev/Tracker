//
//  TrackerNavigationController.swift
//  Tracker
//
//  Created by Давид Бекоев on 28.10.2024.
//

import UIKit
final class TrackersNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = TrackersListViewController()
        pushViewController(view, animated: true)
    }
    
}
