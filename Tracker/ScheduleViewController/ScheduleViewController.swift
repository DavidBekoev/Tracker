//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Давид Бекоев on 13.11.2024.
//
import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectDays(_ days: [WeekDay])
}

final class ScheduleViewController: UIViewController, ConfigurableView {
    
    weak var delegate: ScheduleViewControllerDelegate?
    
    private let weekDays: [WeekDay] = {
           let allDays = WeekDay.allCases
           let startIndex = allDays.firstIndex(of: .monday) ?? 0
           let reorderedDays = allDays[startIndex...] + allDays[..<startIndex]
           return Array(reorderedDays)
       }()
    var selectedDays: Set<WeekDay> = []
    
    private var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        title = "Расписание"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
        ]
        
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        
        setupView()
        setupTableView()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height).isActive = true
    }
    
    func setupView() {
        [tableView, doneButton].forEach{
            view.addSubview($0)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ScheduleTableCell.self, forCellReuseIdentifier: "DaySwitchCell")
        tableView.rowHeight = 75
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: 39),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            //doneButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 39),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        let day = weekDays[sender.tag]
        
        if sender.isOn {
            selectedDays.insert(day)
        } else {
            selectedDays.remove(day)
        }
    }
    
    @objc private func doneTapped() {
        let sortedDays = selectedDays.sorted { (day1, day2) -> Bool in
            guard let index1 = weekDays.firstIndex(of: day1),
                  let index2 = weekDays.firstIndex(of: day2) else {
                return false
            }
            return index1 < index2
        }
        delegate?.didSelectDays(sortedDays)
        dismiss(animated: true, completion: nil)
    }
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DaySwitchCell", for: indexPath) as? ScheduleTableCell else {
                   fatalError("Не удалось deque DaySwitchCell")
               }

        
        let day = weekDays[indexPath.row]
        let isOn = selectedDays.contains(day)

               cell.configure(with: day.displayName, isOn: isOn) { [weak self] isOn in
                   guard let self = self else { return }
                   if isOn {
                       self.selectedDays.insert(day)
                   } else {
                       self.selectedDays.remove(day)
                   }
               }
        
        if indexPath.row == weekDays.count - 1 {
            cell.layer.cornerRadius = 16
                       cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                       cell.clipsToBounds = true
                   } else {
                       cell.layer.cornerRadius = 0
                       cell.clipsToBounds = false
        }
        
        return cell
    }
}
