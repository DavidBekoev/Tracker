//
//  CategoryCreateViewController.swift
//  Tracker
//
//  Created by Давид Бекоев on 14.12.2024.
//

import UIKit

final class CategoryCreateViewController: UIViewController, ConfigurableView {
    private let viewModel: CategoryViewModelProtocol
    
    init(viewModel: CategoryViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не был реализован")
    }
    
    private lazy var categoryNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название категории"
        textField.layer.cornerRadius = 16
        textField.font = .systemFont(ofSize: 17)
        textField.backgroundColor = .background
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var createButton: UIButton = {
        let createButton = UIButton(type: .system)
        createButton.setTitle("Готово", for: .normal)
        createButton.setTitleColor(.white, for: .normal)
        createButton.backgroundColor = .gray
        createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        createButton.layer.cornerRadius = 16
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.isEnabled = false
        return createButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        
        title = "Новая категория"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
        ]
        categoryNameTextField.delegate = self
        
        createButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        [categoryNameTextField, createButton].forEach{
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            categoryNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            categoryNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func updateCreateButtonState() {
        let isFormComplete = categoryNameTextField.text?.isEmpty == false
        
        createButton.isEnabled = isFormComplete
        createButton.backgroundColor = isFormComplete ? .black : .gray
    }
    
    @objc private func textFieldDidChange() {
        updateCreateButtonState()
    }
    
    @objc private func createTapped() {
        guard let categoryName = categoryNameTextField.text, !categoryName.isEmpty else { return }
        viewModel.addCategory(name: categoryName)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extention UITextFieldDelegate

extension CategoryCreateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
