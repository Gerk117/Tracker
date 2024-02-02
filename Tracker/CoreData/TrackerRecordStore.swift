//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 24.01.2024.
//


import CoreData
import UIKit

final class TrackerRecordStore {
    
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
