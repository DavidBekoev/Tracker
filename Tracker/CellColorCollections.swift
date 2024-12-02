//
//  CellColorCollections.swift
//  Tracker
//
//  Created by Давид Бекоев on 26.11.2024.
//

import UIKit

final class CellColorCollection: UICollectionViewCell, ConfigurableView {
    static let identifier = "CellColor"
    private lazy var borderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        contentView.addSubview(borderView)
        borderView.addSubview(colorView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            borderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            colorView.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 6),
            colorView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 6),
            colorView.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -6),
            colorView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -6)
            
        ])
    }
    
    func configure(with color: UIColor, isSelected: Bool) {
        colorView.backgroundColor = color
        borderView.layer.borderWidth = isSelected ? 3 : 0
        borderView.layer.borderColor = isSelected ? color.withAlphaComponent(0.3).cgColor : UIColor.clear.cgColor
    }
}
