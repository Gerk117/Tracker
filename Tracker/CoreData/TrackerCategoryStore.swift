//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 24.01.2024.
//

import UIKit
import CoreData

final class TrackerCategoryStore {
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var trackerStore = TrackerStore()
    
    func returnCategory() -> [TrackerCategory] {
        let trackerCategory = try! context.fetch(TrackerCategoryData.fetchRequest())
        let returnResult = trackerCategory.map({
            convertToTrackerCategory($0)
        })
        return returnResult
    }
    
    func addCategory(_ category : TrackerCategory){
        let categorys = try! context.fetch(TrackerCategoryData.fetchRequest())
        if !categorys.contains(where: {
            $0.name == category.header
        }) {
            let trackerCategory = TrackerCategoryData(context: context)
            trackerCategory.name = category.header
            trackerStore.saveTrackerCoreData(category.trackers[0], trackerCategory)
        } else {
            let request = TrackerCategoryData.fetchRequest()
            request.predicate = NSPredicate(format: "name == %@", category.header)
            let trackerCategory = try! context.fetch(request)
            trackerStore.saveTrackerCoreData(category.trackers[0], trackerCategory[0])
        }
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
    
    private func convertToTrackerCategory(_ trackerCategoryData: TrackerCategoryData) -> TrackerCategory {
        if let trackersCore = trackerCategoryData.trackers?.allObjects as? [TrackerData] {
            let result = trackersCore.map {
                trackerStore.convertToTracker($0)
            }
            return TrackerCategory(header: trackerCategoryData.name ?? "", trackers: result)
        }
        return TrackerCategory(header: "", trackers: [])
    }
}
