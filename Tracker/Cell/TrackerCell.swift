//
//  TrackerCell.swift
//  Tracker
//
//  Created by Давид Бекоев on 13.11.2024.
//

import UIKit

final class TrackerCell: UICollectionViewCell, ConfigurableView {
    
    var markButtonAction: (() -> Void)?
    
    
  
    
    private var trackerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var daysCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var markButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        return button
    }()
    
    
    private var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 16
        stackView.alignment = .leading
        return stackView
    }()
    
    
    private var emojiContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    private var daysStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        markButton.addTarget(self, action: #selector(markButtonTappedAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        emojiContainerView.addSubview(emojiLabel)
        
        [emojiContainerView, trackerTitleLabel].forEach {
            titleStackView.addArrangedSubview($0)
        }
        [daysCountLabel, markButton].forEach {
            daysStackView.addArrangedSubview($0)
        }
        [titleStackView, daysStackView].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            titleStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            titleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            titleStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            titleStackView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.topAnchor.constraint(equalTo: emojiContainerView.topAnchor, constant: 1),
            emojiLabel.leadingAnchor.constraint(equalTo: emojiContainerView.leadingAnchor, constant: 4),
            emojiLabel.trailingAnchor.constraint(equalTo: emojiContainerView.trailingAnchor, constant: -4),
            emojiLabel.bottomAnchor.constraint(equalTo: emojiContainerView.bottomAnchor, constant: -1),
            
            emojiContainerView.topAnchor.constraint(equalTo: titleStackView.topAnchor, constant: 12),
            emojiContainerView.leadingAnchor.constraint(equalTo: titleStackView.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 16),
            emojiLabel.heightAnchor.constraint(equalToConstant: 22),
            
            emojiContainerView.widthAnchor.constraint(equalToConstant: 24),
            emojiContainerView.heightAnchor.constraint(equalToConstant: 24),
            
            trackerTitleLabel.leadingAnchor.constraint(equalTo: titleStackView.leadingAnchor, constant: 12),
            trackerTitleLabel.trailingAnchor.constraint(equalTo: titleStackView.trailingAnchor, constant: -12),
            trackerTitleLabel.bottomAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 12),
            
            daysStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 0),
            daysStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            daysStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            markButton.widthAnchor.constraint(equalToConstant: 34),
            markButton.heightAnchor.constraint(equalToConstant: 34),
        ])
    }
    
    func configure(with tracker: Tracker, isCompleted: Bool, completedDays: Int, isFutureDate: Bool) {
        emojiLabel.text = tracker.emoji
        trackerTitleLabel.text = tracker.title
        titleStackView.backgroundColor = tracker.color
        daysCountLabel.text = daysCountString(count: completedDays)
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 11, weight: .bold)
        let imageName = isCompleted ? "checkmark" : "plus"
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        markButton.setImage(image, for: .normal)
        markButton.backgroundColor = isCompleted ? tracker.color.withAlphaComponent(0.3) : tracker.color
        
        markButton.isEnabled = !isFutureDate
        markButton.alpha = isFutureDate ? 0.5 : 1.0
    }
    
    
    @objc private func markButtonTappedAction() {
        markButtonAction?()
        
    }
    
    private func daysCountString(count: Int) -> String {
        let formatString: String = NSLocalizedString("days_count", comment: "")
        let resultString: String = String.localizedStringWithFormat(formatString,count)
        return resultString
    }
}
