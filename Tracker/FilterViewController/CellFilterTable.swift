//
//  CellFilterTable.swift
//  Tracker
//
//  Created by Давид Бекоев on 23.12.2024.
//

import UIKit

final class CellFilterTable: UITableViewCell, ConfigurableView {
    
    private let filterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .totalBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let selectionIndicator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .ypBlue
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
    
    //    MARK: - Setup Views
    
    func setupView() {
        [filterLabel, selectionIndicator].forEach{
            contentView.addSubview($0)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            filterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            filterLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            selectionIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            selectionIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Public Configuration
    
    func configure(with filterName: String, isSelected: Bool) {
        backgroundColor = .grayDarkGrey
        filterLabel.text = filterName
        selectionIndicator.isHidden = !isSelected
    }
    
}
