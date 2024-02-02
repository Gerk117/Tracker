//
//  CategoryScreenViewModel.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 30.01.2024.
//

import Foundation

class CategoryScreenViewModel {
    
    var onChange: (() -> Void)?
    
    
     private(set) var dataCategory: [String] = [] {
        didSet {
            onChange?()
        }
    }
    func returnCategory(){
        dataCategory = TrackerCategoryStore.shared.returnNamesOfCategory()
        dataCategory.removeFirst()
    }
    var numberOfCategory : Int {
        dataCategory.count
    }
    
}
