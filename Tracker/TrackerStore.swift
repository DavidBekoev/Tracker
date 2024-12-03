
//  TrackerStore.swift
//  Tracker

//  Created by Давид Бекоев on 28.11.2024.


import CoreData
import UIKit

final class TrackerStore {
    static let shared = TrackerStore()
    private let context: NSManagedObjectContext

    private init() {
        self.context = AppDelegate.shared.persistentContainer.viewContext
    }

    func createTracker(id: UUID, title: String, emoji: String, color: UIColor, schedule: [WeekDay], categoryName: String, completion: @escaping (Tracker?) -> Void) {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = id
        trackerCoreData.title = title
        trackerCoreData.emoji = emoji
        trackerCoreData.color = color
        trackerCoreData.schedule = schedule as NSObject

        let categoryRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        categoryRequest.predicate = NSPredicate(format: "title == %@", categoryName)
        let categoryCoreData: TrackerCategoryCoreData
        if let existingCategory = try? context.fetch(categoryRequest).first {
            categoryCoreData = existingCategory
        } else {
            categoryCoreData = TrackerCategoryCoreData(context: context)
            categoryCoreData.title = categoryName
        }

       trackerCoreData.category = categoryCoreData
        categoryCoreData.addToTrackers(trackerCoreData)

        AppDelegate.shared.saveContext()

        let newTracker = Tracker(id: id, title: title, emoji: emoji, color: color, schedule: schedule)
        completion(newTracker)
    }

    func fetchTrackers(completion: @escaping ([Tracker]) -> Void) {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        do {
            let trackerEntities = try context.fetch(request)
            let trackers = trackerEntities.compactMap { entity -> Tracker? in
                guard let id = entity.id,
                      let name = entity.title,
                      let emoji = entity.emoji,
                      let color = entity.color as? UIColor,
                      let schedule = entity.schedule as? [WeekDay] else {
                    return nil
                }
                return Tracker(id: id, title: name, emoji: emoji, color: color, schedule: schedule)
            }
            completion(trackers)
        } catch {
            print("Не удалось получить трекеры: \(error)")
            completion([])
        }
    }
}
