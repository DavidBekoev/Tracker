
 // TrackerRecordStore.swift
 // Tracker

 // Created by Давид Бекоев on 28.11.2024.


import CoreData

final class TrackerRecordStore {
    static let shared = TrackerRecordStore()
    private let context: NSManagedObjectContext

    private init() {
        self.context = AppDelegate.shared.persistentContainer.viewContext
    }

    func addRecord(trackerID: UUID, date: Date, completion: @escaping (Bool) -> Void) {
        let startOfDay = Calendar.current.startOfDay(for: date)
               guard let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) else {
                   completion(false)
                   return
               }

               let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "trackerID == %@ AND date >= %@ AND date < %@", trackerID as CVarArg, startOfDay as NSDate, endOfDay as NSDate)
        do {
            let existingRecords = try context.fetch(request)
                       if existingRecords.isEmpty {
                           let recordCoreData = TrackerRecordCoreData(context: context)
                           recordCoreData.trackerID = trackerID
                           recordCoreData.date = startOfDay
                           try context.save()
                           completion(true)
                       } else {
                           completion(false)
                       }
        } catch {
            print("Не удалось добавить запись: \(error)")
            completion(false)
        }
    }

    func deleteRecord(trackerId: UUID, date: Date, completion: @escaping (Bool) -> Void) {
        let startOfDay = Calendar.current.startOfDay(for: date)
               guard let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) else {
                   completion(false)
                   return
               }
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "trackerID == %@ AND date >= %@ AND date < %@", trackerId as CVarArg, startOfDay as NSDate, endOfDay as NSDate)
        do {
            let records = try context.fetch(request)
            for record in records {
                context.delete(record)
            }
            try context.save()
            completion(true)
        } catch {
            print("Не удалось удалить запись: \(error)")
            completion(false)
        }
    }

    func fetchRecords(completion: @escaping ([TrackerRecord]) -> Void) {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        do {
            let recordEntities = try context.fetch(request)
            let records = recordEntities.compactMap { entity -> TrackerRecord? in
                guard let trackerID = entity.trackerID, let date = entity.date else { return nil }
                return TrackerRecord(date: date, trackerID: trackerID)
            }
            completion(records)
        } catch {
            print("Не удалось получить записи: \(error)")
            completion([])
        }
    }
}
