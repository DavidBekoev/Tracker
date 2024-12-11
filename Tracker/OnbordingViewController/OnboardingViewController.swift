//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Давид Бекоев on 11.12.2024.
//

import UIKit


final class OnboardingViewController: UIPageViewController, ConfigurableView {
    
    var didFinishOnboarding: (() -> Void)?
    
    // MARK: - Inizial
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //    MARK: - Private UI elements
    
    private lazy var pages: [UIViewController] = {
        let firstPage = OnboardingCustomController(pageModel: .firstPage)
        let secondPage = OnboardingCustomController(pageModel: .secondPage)
        return [firstPage, secondPage]
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .black.withAlphaComponent(0.3)
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var skipButton = {
        let button = UIButton()
        button.setTitle("Вот это технологии!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        setupView()
        setupConstraints()
        delegate = self
        dataSource = self
    }
    
    func setupView() {
        [pageControl, skipButton].forEach{
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            skipButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            skipButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            skipButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc private func skipButtonTapped() {
        UserDefaultsSettings.shared.onboardingWasShown = true
        didFinishOnboarding?()
        
    }
}
// MARK: - Extention UIPageViewController

extension OnboardingViewController: UIPageViewControllerDataSource,  UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard var viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }

        viewControllerIndex -= 1

        if viewControllerIndex < 0 {
            viewControllerIndex = pages.count - 1
        }

        return pages[viewControllerIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard var viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }

        viewControllerIndex += 1

        if viewControllerIndex >= pages.count {
            viewControllerIndex = 0
        }

        return pages[viewControllerIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

