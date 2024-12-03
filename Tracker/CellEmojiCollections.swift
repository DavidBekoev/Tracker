//
//  CellEmojiCollections.swift
//  Tracker
//
//  Created by Давид Бекоев on 26.11.2024.
//

import UIKit

final class CellEmojiCollection: UICollectionViewCell, ConfigurableView {
    static let identifier = "CellEmoji"
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var viewBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
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
        contentView.addSubview(viewBackground)
        viewBackground.addSubview(emojiLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([

            viewBackground.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            viewBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            emojiLabel.centerXAnchor.constraint(equalTo: viewBackground.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: viewBackground.centerYAnchor)
        ])
    }

    func configure(with emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        viewBackground.backgroundColor = isSelected ? UIColor.background : UIColor.clear
    }
}
