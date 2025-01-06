
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
    
    func deleteTracker(_ tracker: Tracker, completion: @escaping (Bool) -> Void) {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id.uuidString)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let trackerToDelete = results.first {
                context.delete(trackerToDelete)
                try context.save()
                completion(true)
            } else {
                completion(false)
            }
        } catch {
            print("Не удалось удалить трекер: \(error)")
            completion(false)
        }
    }
    
    func updateTracker(_ tracker: Tracker, title: String, emoji: String, color: UIColor, schedule: [WeekDay], categoryName: String, completion: @escaping (Bool) -> Void) {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id.uuidString)
        
        do {
            if let trackerCoreData = try context.fetch(request).first {
                trackerCoreData.title = title
                trackerCoreData.emoji = emoji
                trackerCoreData.color = color
                trackerCoreData.schedule = schedule as NSObject
                
                if trackerCoreData.category?.title != categoryName {
                    let categoryRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
                    categoryRequest.predicate = NSPredicate(format: "title == %@", categoryName)
                    let categoryCoreData: TrackerCategoryCoreData
                    if let existingCategory = try context.fetch(categoryRequest).first {
                        categoryCoreData = existingCategory
                    } else {
                        categoryCoreData = TrackerCategoryCoreData(context: context)
                        categoryCoreData.title = categoryName
                    }
                    trackerCoreData.category = categoryCoreData
                }
                
                try context.save()
                completion(true)
            } else {
                completion(false)
            }
        } catch {
            print("Не удалось обновить трекер: \(error)")
            completion(false)
        }
    }
    func fetchCategory(for trackerId: UUID) -> TrackerCategory? {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "ANY trackers.id == %@", trackerId.uuidString)
        
        do {
            if let category = try context.fetch(request).first {
                return TrackerCategory(
                    title: category.title ?? "",
                    trackers: []
                )
            }
        } catch {
            print("Ошибка получения категории: \(error)")
        }
        return nil
    }
    
}
