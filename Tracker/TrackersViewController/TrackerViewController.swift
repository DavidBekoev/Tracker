//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Давид Бекоев on 28.10.2024.
//
import UIKit

final class TrackerViewController: UIViewController, NewHabitCreateViewControllerDelegate, ConfigurableView  {
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var visibleCategories: [TrackerCategory] = []
    private var currentDate: Date = Date()
    
    private let trackerStore = TrackerStore.shared
      private let categoryStore = TrackerCategoryStore.shared
      private let recordStore = TrackerRecordStore.shared
    
    private lazy var addTrackerButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(named: "Pluus"),
            style: .plain,
            target: self,
            action: #selector(addTrackerTapped)
        )
        button.tintColor = .black
        return button
    }()
    
    private lazy var choiceDate: UIBarButtonItem = {
        let navBarButton = UIBarButtonItem(customView: datePicker)
        return navBarButton
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = Locale.current
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.date = Date()
        return picker
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 34)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var searchBar: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.placeholder = "Поиск"
        return searchController
    }()
    
    private var starImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Звезда")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var errorLable: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    private var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 7
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var starStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavBar()
        setupView()
        setupConstraints()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        // Получаем данные из Core Data
               fetchCategories()
               fetchCompletedTrackers()
               filterTrackersForSelectedDate()
        
        updateViewVisibility()
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = addTrackerButton
        navigationItem.rightBarButtonItem = choiceDate
    }
    
    // MARK: - Get Core Data

       private func fetchCategories() {
           categoryStore.fetchCategories { [weak self] categories in
               DispatchQueue.main.async {
                   self?.categories = categories
                   self?.filterTrackersForSelectedDate()
                   self?.updateViewVisibility()
               }
           }
       }

       private func fetchCompletedTrackers() {
           recordStore.fetchRecords { [weak self] records in
               DispatchQueue.main.async {
                   self?.completedTrackers = Set(records)
                   self?.collectionView.reloadData()
                   self?.filterTrackersForSelectedDate()
               }
           }
       }

    
    func setupView() {
        [titleLabel, searchBar.searchBar].forEach{
            infoStackView.addArrangedSubview($0)
        }
        [starImage,errorLable].forEach{
            starStackView.addArrangedSubview($0)
        }
        [infoStackView, collectionView, starStackView].forEach{
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            infoStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            infoStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            searchBar.searchBar.heightAnchor.constraint(equalToConstant: 36),
            searchBar.searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            searchBar.searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            collectionView.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            starStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 66),
        ])
    }
    
    private func updateViewVisibility() {
        if visibleCategories.isEmpty {
            starStackView.isHidden = false
            collectionView.isHidden = true
        } else {
            starStackView.isHidden = true
            collectionView.isHidden = false
            collectionView.reloadData()
        }
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        filterTrackersForSelectedDate()
    }
    
    @objc private func addTrackerTapped() {
        let createTrackerViewController = TrackerCreateViewController()
        createTrackerViewController.delegate = self
        let navController = UINavigationController(rootViewController: createTrackerViewController)
        present(navController, animated: true, completion: nil)
    }
    
    func didCreateNewTracker(_ tracker: Tracker, categoryName: String) {
        fetchCategories()
    }
    
    private func markButtonTapped(at indexPath: IndexPath) {
        let selectedDate = Calendar.current.startOfDay(for: currentDate)
        let today = Calendar.current.startOfDay(for: Date())
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.item]
        
        guard selectedDate <= today else {
            return
        }
        
        let record = TrackerRecord(date: selectedDate, trackerID: tracker.id)
        
        if completedTrackers.contains(record) {
            recordStore.deleteRecord(trackerId: tracker.id, date: selectedDate) { [weak self] success in
                           if success {
                               self?.completedTrackers.remove(record)
                               DispatchQueue.main.async {
                                   self?.collectionView.reloadItems(at: [indexPath])
                               }
                           }
                       }
        } else {
            recordStore.addRecord(trackerID: tracker.id, date: selectedDate) { [weak self] success in
                           if success {
                               self?.completedTrackers.insert(record)
                               DispatchQueue.main.async {
                                   self?.collectionView.reloadItems(at: [indexPath])
                               }
                           }
                       }
        }
    }
    
    private func filterTrackersForSelectedDate() {
        let selectedDate = currentDate
        let calendar = Calendar.current
        let selectedWeekdayNumber = calendar.component(.weekday, from: selectedDate)
        
        guard let selectedWeekday = WeekDay(rawValue: selectedWeekdayNumber) else {
            visibleCategories = []
            collectionView.reloadData()
            updateViewVisibility()
            return
        }
        
        visibleCategories = categories.compactMap { category in
            let trackersForDate = category.trackers.filter { tracker in
                return tracker.schedule.contains(selectedWeekday)
            }
            if trackersForDate.isEmpty {
                return nil
            } else {
                return TrackerCategory(title: category.title, trackers: trackersForDate)
            }
        }
        
        collectionView.reloadData()
        updateViewVisibility()
    }
    
}

extension TrackerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.item]
        let selectedDate = currentDate
        let isFutureDate = Calendar.current.compare(selectedDate, to: Date(), toGranularity: .day) == .orderedDescending
        
        let isCompleted = completedTrackers.contains { record in
            record.trackerID == tracker.id && Calendar.current.isDate(record.date, inSameDayAs: selectedDate)
        }
        let completedDays = completedTrackers.filter { $0.trackerID == tracker.id }.count
        
        cell.configure(with: tracker, isCompleted: isCompleted, completedDays: completedDays, isFutureDate: isFutureDate)
        cell.markButtonAction = { [weak self] in
            self?.markButtonTapped(at: indexPath)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.identifier, for: indexPath) as? SectionHeader else {
            return UICollectionReusableView()
        }
        header.nameLabel.text = visibleCategories[indexPath.section].title
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interItemSpacing: CGFloat = 7
        let availableWidth = collectionView.bounds.width - interItemSpacing
        let width = availableWidth / 2
        return CGSize(width: width, height: 141)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 16, right: 0)
    }
}
