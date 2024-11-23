//
//  UIView + Extentions.swift
//  Tracker
//
//  Created by Давид Бекоев on 28.10.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
}

protocol ConfigurableView {
    func setupView()
    func setupConstraints()
}

