//
//  TrackerCreateViewController.swift
//  Tracker
//
//  Created by Давид Бекоев on 07.11.2024.
//

import UIKit

final class TrackerCreateViewController: UIViewController, ConfigurableView {
    
    weak var delegate: NewHabitCreateViewControllerDelegate?
    
    
    private var buttonHabit: UIButton = {
        let button = UIButton()
        button.setTitle("Привычка", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    private var buttonEvent: UIButton = {
        let button = UIButton()
        button.setTitle("Нерегулярное событие", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    
    private var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        setupConstraints()
        
        title = "Создание трекера"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
        ]
        
        buttonEvent.addTarget(self, action: #selector(createNewEvent), for: .touchUpInside)
        buttonHabit.addTarget(self, action: #selector(createNewHabit), for: .touchUpInside)
    }
    
    
    func setupView() {
        [buttonHabit, buttonEvent].forEach{
            buttonStackView.addArrangedSubview($0)
        }
        view.addSubview(buttonStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            buttonHabit.heightAnchor.constraint(equalToConstant: 60),
            buttonEvent.heightAnchor.constraint(equalToConstant: 60),
            
            buttonStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    
    @objc private func createNewHabit() {
        let newHabitCreateViewController = NewHabitCreateViewController()
        newHabitCreateViewController.delegate = delegate
        navigationController?.pushViewController(newHabitCreateViewController, animated: true)
    }
    
    @objc private func createNewEvent() {
        let newEventCreateViewController = NewEventCreateViewController()
        navigationController?.pushViewController(newEventCreateViewController, animated: true)
    }
}
