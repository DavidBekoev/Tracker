//
//  ScheduleTableCell.swift
//  Tracker
//
//  Created by Давид Бекоев on 14.12.2024.
//

import UIKit

final class ScheduleTableCell: UITableViewCell, ConfigurableView {
    
    private var switchAction: ((Bool) -> Void)?
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var switchView: UISwitch = {
        let switchControl = UISwitch(frame: .zero)
        switchControl.onTintColor = .blue
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
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
        selectionStyle = .none
        [dayLabel, switchView].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            switchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            switchView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func configure(with dayName: String, isOn: Bool, switchAction: @escaping (Bool) -> Void) {
        backgroundColor = .background
        dayLabel.text = dayName
        switchView.setOn(isOn, animated: true)
        self.switchAction = switchAction
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
    
    @objc private func switchChanged() {
        switchAction?(switchView.isOn)
    }
}
