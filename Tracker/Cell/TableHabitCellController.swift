//
//  TableHabitCellController.swift
//  Tracker
//
//  Created by Давид Бекоев on 14.11.2024.
//
//
import UIKit
final class TableHabitCellController: UITableViewCell, ConfigurableView {
    private let textDetailLable = NSLocalizedString("every day", comment: "")
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .totalBlack
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
    
    func config(title: String, selectedDays: [WeekDay]?, categoryName: String?, isScheduleRow: Bool) {
        nameLabel.text = title
        backgroundColor = .grayDarkGrey
        
        if isScheduleRow, let selectedDays = selectedDays {
            let allDays = WeekDay.allCases.filter {
                switch $0 {
                case .sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday:
                    return true
                case .specificDate:
                    return false
                }
            }
            
            if Set(selectedDays) == Set(allDays) {
                detailLabel.text = textDetailLable
            } else {
                let sortedDays = selectedDays.sorted {
                    $0.weekdayIndex < $1.weekdayIndex
                }
                detailLabel.text = sortedDays
                    .map { $0.shortDisplayName }
                    .joined(separator: ", ")
            }
        } else if !isScheduleRow, let categoryName = categoryName {
            detailLabel.text = categoryName
        } else {
            detailLabel.text = nil
        }
    }
    
}
