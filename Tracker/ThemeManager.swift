//
//  ThemeManager.swift
//  Tracker
//
//  Created by Давид Бекоев on 22.12.2024.
//

import UIKit

final class ThemeManager {
    static let shared = ThemeManager()
    
    private init() {}
    
    var tabBarBorder: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .totalBlack : .gray
        }
    }
    
    var separatorColor: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .lightGray : .gray
        }
    }
}
