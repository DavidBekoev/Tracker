//
//  OnboardingCustomController.swift
//  Tracker
//
//  Created by Давид Бекоев on 11.12.2024.
//

import UIKit

final class OnboardingCustomController: UIViewController, ConfigurableView {
    private var pageModel: PageModel?

    // MARK: - Inizial

    init(pageModel: PageModel) {
          self.pageModel = pageModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //    MARK: - Private UI Elements

    private lazy var labelTitle = {
        let label = UILabel()
        label.text = pageModel?.text
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

  
    
    private lazy var backgroundImage = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let image = pageModel?.imageName {
            imageView.image = image
        } else {
            imageView.backgroundColor = .white
        }
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    func setupView() {
        [backgroundImage, labelTitle].forEach{
            view.addSubview($0)
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([

            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        ])
    }
}
