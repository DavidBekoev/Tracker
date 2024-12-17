//
//  PageModel.swift
//  Tracker
//
//  Created by Давид Бекоев on 11.12.2024.
//

import UIKit

enum PageModel {
    case firstPage
    case secondPage

    var imageName: UIImage? {
        switch self {
        case .firstPage:
            return UIImage(named: "blue_image")
        case .secondPage:
            return UIImage(named: "red_image")
        }
    }

    var text: String {
        switch self {
        case .firstPage:
            return "Отслеживайте только то, что хотите"
        case .secondPage:
            return "Даже если это не литры воды и йога"
        }
    }
}
