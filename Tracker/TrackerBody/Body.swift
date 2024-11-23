//
//  Body.swift
//  Tracker
//
//  Created by Давид Бекоев on 14.11.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let emoji: String
    let color: UIColor
    let schedule: [WeekDay]
}

struct TrackerRecord: Hashable {
    let date: Date
    let trackerID: UUID
}

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
}
