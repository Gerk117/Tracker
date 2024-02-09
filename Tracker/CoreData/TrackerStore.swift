//
//  TrackerStore.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 24.01.2024.
//

import CoreData
import UIKit

final class TrackerStore {

    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func convertToTracker(_ trackerData: TrackerData) -> TrackerModel {
        let id = trackerData.id
        let name = trackerData.name
        let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: trackerData.color ?? Data())
        let emoji = trackerData.emoji
        let schedule = try? JSONDecoder().decode([WeekDay].self, from: trackerData.shedule ?? Data())
        let regularValue = trackerData.regular
        let isPinned = trackerData.isPinned
        let tracker = TrackerModel(id: id ?? UUID(),
                                   name: name ?? "",
                                   colorName: color ?? UIColor(),
                                   emoji: emoji ?? "",
                                   schedule: schedule ?? [],
                                   isRegular: regularValue,
                                   isPinned: isPinned)
        return tracker
    }
    func convertToTrackerData(id : UUID) -> TrackerData? {
        let request = TrackerData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let tracker = try? context.fetch(request).first else {
            return nil
        }
        return tracker
    }
    
    func changeTracker(_ changedTracker : TrackerModel , _ categoryName : String ){
        let request = TrackerData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", changedTracker.id as CVarArg)
        guard let tracker = try? context.fetch(request).first else {return}
        tracker.id = changedTracker.id
        tracker.name = changedTracker.name
        tracker.emoji = changedTracker.emoji
        tracker.color = try? NSKeyedArchiver.archivedData(withRootObject: changedTracker.colorName, requiringSecureCoding: false)
        tracker.shedule  = try? JSONEncoder().encode(changedTracker.schedule)
        tracker.regular = changedTracker.isRegular
        tracker.lastCategory = categoryName
        let categoryRequest = TrackerCategoryData.fetchRequest()
        categoryRequest.predicate = NSPredicate(format: "name == %@", categoryName)
        guard let category = try? context.fetch(categoryRequest).first else {
            return
        }
        category.addToTrackers(tracker)
        try? saveContext()
        
    }
    
    
    func saveTrackerCoreData(_ tracker: TrackerModel, _ categoryName: String) {
        let request = TrackerCategoryData.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", categoryName)
        guard let category = try? context.fetch(request).first else {return}
        let newTracker = TrackerData(context: context)
        newTracker.id = tracker.id
        newTracker.name = tracker.name
        newTracker.emoji = tracker.emoji
        newTracker.color = try? NSKeyedArchiver.archivedData(withRootObject: tracker.colorName, requiringSecureCoding: false)
        newTracker.shedule  = try? JSONEncoder().encode(tracker.schedule)
        newTracker.regular = tracker.isRegular
        newTracker.lastCategory = categoryName
        category.addToTrackers(newTracker)
        try? saveContext()
    }
    
    func deleteTracker(_ id : UUID) {
        let request = TrackerData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let tracker = try? context.fetch(request).first else {return}
        context.delete(tracker)
        try? saveContext()
    }
    
    func pinTracker(id : UUID){
        let request = TrackerData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let tracker = try? context.fetch(request).first else {
            return
        }
        tracker.isPinned = true
        let categoryRequest = TrackerCategoryData.fetchRequest()
        categoryRequest.predicate = NSPredicate(format: "name == %@",NSLocalizedString("Закрепленные", comment: ""))
        guard let category = try? context.fetch(categoryRequest).first else {
            return
        }
        category.addToTrackers(tracker)
        try? saveContext()
    }
    
    func unPinTracker(id : UUID){
        let request = TrackerData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let tracker = try? context.fetch(request).first else {
            return
        }
        tracker.isPinned = false
        let categoryRequest = TrackerCategoryData.fetchRequest()
        categoryRequest.predicate = NSPredicate(format: "name == %@",tracker.lastCategory!)
        let category = try? context.fetch(categoryRequest).first
        category?.addToTrackers(tracker)
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
