//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Давид Бекоев on 28.10.2024.
//
import UIKit

final class TrackersListViewController: UIViewController {
    
    let addTrackerButton: UIButton = .init()
    let datePicker: UIDatePicker = .init()
    let emptyListView = UIImageView()
    let emptyListLabel = configLabel(
        font: UIFont.systemFont(ofSize: 12, weight: .light),
        color: .black
    )
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageButton = UIImage(named: "+")
        addTrackerButton.setImage(imageButton, for: .normal)
        addTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addTrackerButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = UISearchController()
        
        let emptyListImage = UIImage(named: "Звезда")
        emptyListView.image = emptyListImage
        emptyListView.translatesAutoresizingMaskIntoConstraints = false
            
        emptyListLabel.text = "Что будем отслеживать?"
        view.addSubviews([emptyListView, emptyListLabel])
        addConstraints()
        
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            emptyListView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyListView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyListView.heightAnchor.constraint(equalToConstant: 80),
            emptyListView.widthAnchor.constraint(equalToConstant: 80),
            emptyListLabel.centerXAnchor.constraint(equalTo: emptyListView.centerXAnchor),
            emptyListLabel.topAnchor.constraint(equalTo: emptyListView.bottomAnchor, constant: 8),
            datePicker.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private static func configLabel(font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = color
        return label
    }
    
}
