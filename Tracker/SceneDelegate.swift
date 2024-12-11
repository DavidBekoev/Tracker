//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Давид Бекоев on 25.10.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        if UserDefaultsSettings.shared.onboardingWasShown {
                   switchToMainViewController()
               } else {
                   let onboardingVC = OnboardingViewController()
                   onboardingVC.didFinishOnboarding = { [weak self] in
                       self?.switchToMainViewController()
                   }
                   window?.rootViewController = onboardingVC
               }
           }

           private func switchToMainViewController() {
               let tabBarController = TabBarController()
               tabBarController.modalTransitionStyle = .crossDissolve
               tabBarController.modalPresentationStyle = .fullScreen
             
               guard let window = window else {
            window?.rootViewController = tabBarController
                   return
                  }
               UIView.transition(with: window, duration: 0.2, options: .transitionCrossDissolve, animations: {
                         window.rootViewController = tabBarController
                     })
    }
    
}

