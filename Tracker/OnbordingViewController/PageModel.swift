//
//  PageModel.swift
//  Tracker
//
//  Created by Давид Бекоев on 11.12.2024.
//

import UIKit

private let titleFirstPage = NSLocalizedString("title_first_screen", comment: "")
private let titleSecondPage = NSLocalizedString("title_second_screen", comment: "")

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
            return titleFirstPage
        case .secondPage:
            return titleSecondPage
        }
    }
}
