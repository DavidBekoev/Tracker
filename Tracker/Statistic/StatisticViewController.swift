//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Давид Бекоев on 27.10.2024.
//

import UIKit

final class StatisticsController: UIViewController {
    let emptyListView = UIImageView()
    let emptyListLabel = configLabel(
        font: UIFont.systemFont(ofSize: 12, weight: .light),
        color: .black
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Cтатистика"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let emptyListImage = UIImage(named: "Смайл")
        emptyListView.image = emptyListImage
        emptyListView.translatesAutoresizingMaskIntoConstraints = false
        
        emptyListLabel.text = "Анализировать пока нечего"
        
        view.addSubviews([emptyListView, emptyListLabel])
        addConstrains()
    }
    
    private func addConstrains() {
        NSLayoutConstraint.activate([
            emptyListView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyListView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyListView.heightAnchor.constraint(equalToConstant: 80),
            emptyListView.widthAnchor.constraint(equalToConstant: 80),
            emptyListLabel.centerXAnchor.constraint(equalTo: emptyListView.centerXAnchor),
            emptyListLabel.topAnchor.constraint(equalTo: emptyListView.bottomAnchor, constant: 8)
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

