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

enum WeekDay: Int, CaseIterable {
    
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    
    var displayName: String {
        switch self {
        case .sunday:
            return "Воскресенье"
        case .monday:
            return "Понедельник"
        case .tuesday:
            return "Вторник"
        case .wednesday:
            return "Среда"
        case .thursday:
            return "Четверг"
        case .friday:
            return "Пятница"
        case .saturday:
            return "Суббота"
        }
    }
    
    var shortDisplayName: String {
        switch self {
        case .sunday:
            return "Вс"
        case .monday:
            return "Пн"
        case .tuesday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Сб"
        }
    }
}

enum TrackerDataType: Int, CaseIterable {
    case category
    case schedule
    
    var displayName: String {
        switch self {
        case .category:
            return "Категория"
        case .schedule:
            return "Расписание"
        }
    }
}
