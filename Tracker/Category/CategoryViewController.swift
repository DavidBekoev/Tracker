//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Давид Бекоев on 14.12.2024.
//

import UIKit

protocol CategorySelectionDelegate: AnyObject {
    func didSelectCategory(_ category: TrackerCategory)
}

protocol CategoryViewModelProtocol: AnyObject {
    var categories: [TrackerCategory] { get }
    var onCategoriesUpdated: (([TrackerCategory]) -> Void)? { get set }
    func fetchCategories()
    func addCategory(name: String)
}

final class CategoryViewController: UIViewController, ConfigurableView {
    
    private let viewModel: CategoryViewModelProtocol
    private var selectedCategory: TrackerCategory?
    weak var delegate: CategorySelectionDelegate?
    
    
    init(viewModel: CategoryViewModelProtocol, selectedCategory: TrackerCategory? = nil) {
        self.viewModel = viewModel
        self.selectedCategory = selectedCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var starImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Звезда")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно\nобъединить по смыслу"
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.rowHeight = 75
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createCategoryTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var starStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        title = "Категория"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
        ]
        setupView()
        setupConstraints()
        setupTableView()
        fetchCategories()
        updateViewVisibility()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryTableCell.self, forCellReuseIdentifier: "CategoryTableViewCell")
        tableView.tableFooterView = UIView()
    }
    
    func setupView() {
        [starImage, errorLabel].forEach{
            starStackView.addArrangedSubview($0)
        }
        [starStackView, tableView, addCategoryButton].forEach{
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            starStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -28),
            
            
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Private Methods
    
    private func fetchCategories() {
        viewModel.onCategoriesUpdated = { [weak self] categories in
            DispatchQueue.main.async {
                self?.updateViewVisibility()
                self?.tableView.reloadData()
            }
        }
        viewModel.fetchCategories()
    }
    
    private func updateViewVisibility() {
        if viewModel.categories.isEmpty {
            starStackView.isHidden = false
            tableView.isHidden = true
        } else {
            starStackView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    
    @objc private func createCategoryTapped() {
        let createCategoryVC = CategoryCreateViewController(viewModel: viewModel)
        navigationController?.pushViewController(createCategoryVC, animated: true)
    }
}

// MARK: - Extension TableView

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? CategoryTableCell else {
            fatalError("Не удалось dequeCategoryTableViewCell")
        }
        
        let category = viewModel.categories[indexPath.row]
        let isSelected = category.title == selectedCategory?.title
        
        cell.configure(with: category.title, isSelected: isSelected)
        
        if indexPath.row == viewModel.categories.count - 1 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.clipsToBounds = true
        } else {
            cell.layer.cornerRadius = 0
            cell.clipsToBounds = false
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = viewModel.categories[indexPath.row]
        selectedCategory = selected
        
        tableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            self.delegate?.didSelectCategory(selected)
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
}
