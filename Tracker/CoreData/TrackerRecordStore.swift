//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 24.01.2024.
//


import CoreData
import UIKit

final class TrackerRecordStore {
    
    static let shared = TrackerRecordStore()
    
    private init(){}
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func addRecord(trackerRecord : TrackerRecord){
        let record = convertToTrackerRecordData(tracker: trackerRecord)
        let request = TrackerData.fetchRequest()
        guard let id = record.id else {
            return
        }
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let tracker = try? context.fetch(request).first else {
            return
        }
        tracker.addToRecord(record)
        try? saveContext()
    }
    
    func removeRecord(trackerRecord : TrackerRecord) {
        let request = TrackerRecordData.fetchRequest()
        let components = Calendar.current.dateComponents([.day, .year, .month], from: trackerRecord.date)
        guard let date = Calendar.current.date(from: components) else {
            return
        }
        request.predicate = NSPredicate(format: "id == %@ AND date == %@", trackerRecord.id as CVarArg, date as NSDate)
        guard let records = try? context.fetch(request) else {
            return
        }
        records.forEach {
            context.delete($0)
        }
        try? saveContext()
    }
    
    func returnTrackersRecord() -> [TrackerRecord]{
        let records = try? context.fetch(TrackerRecordData.fetchRequest())
        let returnRecords = records?.map({
            let result = TrackerRecord(id: $0.id ?? UUID(), date: $0.date ?? Date())
            return result
        })
        return returnRecords ?? []
    }
    
    func completedToday(id : UUID , date : Date) -> Bool{
        let request = TrackerRecordData.fetchRequest()
        let components = Calendar.current.dateComponents([.day, .year, .month], from: date)
        guard let date = Calendar.current.date(from: components) else {
            return false
        }
        request.predicate = NSPredicate(format: "id == %@ AND date == %@", id as CVarArg, date as NSDate)
        guard let records = try? context.fetch(request).first else {
            return false
        }
        return true
    }
    
    func numberOfCompleted() -> Int{
        guard let number = try? context.fetch(TrackerRecordData.fetchRequest()) else {
            return 0
        }
        return number.count
    }
    
    func bestDay() -> Int {
        let fetchRequest = TrackerRecordData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let records = try? context.fetch(fetchRequest)
        
        guard let firstRecord = records?.first else {
            return 0
        }
        
        let firstDate = firstRecord.date ?? Date()
        
        var bestDay: (Date, Int) = (firstDate, 0)
        
        for record in records ?? [] {
            let date = record.date ?? Date()
            let components = Calendar.current.dateComponents([.day, .year, .month], from: date)
            let currentDate = Calendar.current.date(from: components) ?? Date()
            
            if Calendar.current.isDate(currentDate, inSameDayAs: firstDate) {
                bestDay.1 += 1
            } else {
                if bestDay.1 < records?.count ?? 0 {
                    bestDay = (currentDate, 1)
                }
            }
        }
        
        return bestDay.1
    }
    
    func maximumNumberOfExecutedDays() -> Int {
        let fetchRequest: NSFetchRequest<TrackerRecordData> = TrackerRecordData.fetchRequest()
        let sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.sortDescriptors = sortDescriptors
        
        let records = try? context.fetch(fetchRequest)
        
        var executedDays: [Date: Int] = [:]
        
        for record in records ?? [] {
            let date = record.date ?? Date()
            let components = Calendar.current.dateComponents([.day, .year, .month], from: date)
            let currentDate = Calendar.current.date(from: components) ?? Date()
            
            if let count = executedDays[currentDate] {
                executedDays[currentDate] = count + 1
            } else {
                executedDays[currentDate] = 1
            }
        }
        
        return executedDays.count
    }
    
    func averageValueOfCompletedTrackers() -> Int {
        guard let category = try? context.fetch(TrackerCategoryData.fetchRequest()) else {
            return 0
        }
        var allTrackers = 0
        category.forEach {
            allTrackers += $0.trackers?.count ?? 0
        }
        return allTrackers / numberOfCompleted()
    }
    
    private func convertToTrackerRecordData(tracker : TrackerRecord) -> TrackerRecordData {
        let trackerRecord = TrackerRecordData(context: context)
        trackerRecord.id = tracker.id
        let components = Calendar.current.dateComponents([.day, .year, .month], from: tracker.date)
        trackerRecord.date = Calendar.current.date(from: components)
        return trackerRecord
    }
    
    private func saveContext() throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }
}
