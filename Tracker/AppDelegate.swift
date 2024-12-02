//
//  AppDelegate.swift
//  Tracker
//
//  Created by Давид Бекоев on 25.10.2024.
//

import UIKit
import CoreData
@main

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        WeekdayTransformer.register()
              ColorTransformer.register()
        return true
    }
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tracker")
               container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                   if let error = error as NSError? {
                       fatalError("Unresolved error \(error), \(error.userInfo)")
                                  }
                              })
                              return container
                          }()
    
    static var shared: AppDelegate {
           guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
               fatalError("Unable to retrieve AppDelegate")
           }
           return delegate
       }
    
    
    func saveContext () {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }


