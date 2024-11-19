//
//  TableHabitCellController.swift
//  Tracker
//
//  Created by Давид Бекоев on 14.11.2024.
//
//
import UIKit
final class TableHabitCellController: UITableViewCell, ConfigurableView {
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    private var detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        [nameLabel, detailLabel].forEach{
            stackView.addArrangedSubview($0)
        }
        [stackView, arrowImageView].forEach{
            addSubview($0)
        }
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -10),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func config(title: String, selectedDays: [WeekDay]?, isCategoryRow: Bool) {
        nameLabel.text = title
        backgroundColor = .background
        
        if isCategoryRow, let selectedDays = selectedDays {
            let allDays = Set(WeekDay.allCases)
            if Set(selectedDays) == allDays {
                detailLabel.text = "Каждый день"
            } else {
                detailLabel.text = selectedDays
                    .sorted(by: { $0.rawValue < $1.rawValue })
                    .map { $0.shortDisplayName }
                    .joined(separator: ", ")
            }
        } else {
            detailLabel.text = nil
        }
    }
}
