//
//  CategoryTableCell.swift
//  Tracker
//
//  Created by Давид Бекоев on 14.12.2024.
//

import UIKit

final class CategoryTableCell: UITableViewCell, ConfigurableView {
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let selectionIndicator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .blue
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        [categoryLabel, selectionIndicator].forEach{
            addSubview($0)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            selectionIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            selectionIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    
    func configure(with categoryName: String, isSelected: Bool) {
        backgroundColor = .background
        categoryLabel.text = categoryName
        selectionIndicator.isHidden = !isSelected
    }
    
}
