//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 24.01.2024.
//

import CoreData
import UIKit


final class TrackerCategoryStore {
    
    static var shared = TrackerCategoryStore()
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var trackerStore = TrackerStore()
    
    private init(){
        guard !UserDefaults.standard.bool(forKey: "notFirstLaunch") else {
            return
        }
        let category = TrackerCategoryData(context: context)
        category.name = NSLocalizedString("Закрепленные", comment: "")
        try? saveContext()
        UserDefaults.standard.setValue(true, forKey: "notFirstLaunch")
    }
    
    func returnCategory() -> [TrackerCategory] {
        guard let trackerCategory = try? context.fetch(TrackerCategoryData.fetchRequest()) else {
            return [TrackerCategory]()
        }
        let returnResult = trackerCategory.map({
            convertToTrackerCategory($0)
        })
        return returnResult
    }
    
    
    func returnNamesOfCategory() -> [String] {
        guard let categorys = try? context.fetch(TrackerCategoryData.fetchRequest()) else {
            return []
        }
        let result = categorys.compactMap({
            "\($0.name ?? "")"
        })
        return result
    }
    
    func addCategory(_ categoryName : String){
        guard let categorys = try? context.fetch(TrackerCategoryData.fetchRequest()) else {
            return
        }
        if !categorys.contains(where: {
            $0.name == categoryName
        }) {
            let trackerCategory = TrackerCategoryData(context: context)
            trackerCategory.name = categoryName
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
