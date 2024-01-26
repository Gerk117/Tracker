//
//  TrackerStore.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 24.01.2024.
//

import UIKit
import CoreData

final class TrackerStore {
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func convertToTracker(_ trackerData: TrackerData) -> TrackerModel {
        let id = trackerData.id!
        let name = trackerData.name!
        let color = try! NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: trackerData.color!)
        let emoji = trackerData.emoji!
        let schedule = try! JSONDecoder().decode([WeekDay].self, from: trackerData.shedule!)
        var tracker = TrackerModel(id: id, name: name, colorName: color!, emoji: emoji, schedule: schedule )
        return tracker
    }
    
    func saveTrackerCoreData(_ tracker: TrackerModel, _ category: TrackerCategoryData) {
        let newTracker = TrackerData(context: context)
        newTracker.id = tracker.id
        newTracker.name = tracker.name
        newTracker.emoji = tracker.emoji
        newTracker.color = try! NSKeyedArchiver.archivedData(withRootObject: tracker.colorName, requiringSecureCoding: false)
        newTracker.shedule  = try! JSONEncoder().encode(tracker.schedule)
        newTracker.category = category
        try? saveContext()
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
