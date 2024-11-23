//
//  Header.swift
//  Tracker
//
//  Created by Давид Бекоев on 13.11.2024.
//

import UIKit

final class SectionHeader: UICollectionReusableView, ConfigurableView {
    static let identifier = "section-header-identifier"
    var nameLabel: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.adjustsFontForContentSizeCategory = true
        lable.font = UIFont.boldSystemFont(ofSize: 19)
        lable.textAlignment = .left
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        addSubview(nameLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
