//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 14.12.2023.
//

import Foundation

struct TrackerCategory {
    let header : String
    let trackers : [TrackerModel]
}

extension TrackerCategory : Equatable {
    static func == (lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        lhs.header == rhs.header
    }
    
    
}
