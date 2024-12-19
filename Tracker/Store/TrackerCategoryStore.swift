
 // TrackerCategoryStore.swift
 // Tracker

 // Created by Давид Бекоев on 28.11.2024.


import CoreData
import UIKit

final class TrackerCategoryStore {
    static let shared = TrackerCategoryStore()
    private let context: NSManagedObjectContext

    private init() {
        self.context = AppDelegate.shared.persistentContainer.viewContext
    }

    func createCategory(title: String, completion: @escaping (TrackerCategory?) -> Void) {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)

                do {
                    let existingCategories = try context.fetch(request)
                    if !existingCategories.isEmpty {
                        completion(nil)
                        return
                    }
                } catch {
                    completion(nil)
                    return
                }
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.title = title

        AppDelegate.shared.saveContext()

        let newCategory = TrackerCategory(title: title, trackers: [])
        completion(newCategory)
    }

    func fetchCategories(completion: @escaping ([TrackerCategory]) -> Void) {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        do {
            let categoryEntities = try context.fetch(request)
            let categories = categoryEntities.compactMap { entity -> TrackerCategory? in
                guard let title = entity.title else {
                    return nil
                }
                let trackersSet = entity.trackers as? Set<TrackerCoreData> ?? []
                let trackerModels = trackersSet.compactMap { trackerEntity in
                    Tracker(id: trackerEntity.id ?? UUID(),
                            title: trackerEntity.title ?? "",
                            emoji: trackerEntity.emoji ?? "",
                            color: trackerEntity.color as? UIColor ?? UIColor.black,
                            schedule: trackerEntity.schedule as? [WeekDay] ?? [])
                }
                return TrackerCategory(title: title, trackers: trackerModels)
                      }
                      completion(categories)
                  } catch {
                      completion([])
                  }
              }
          }
