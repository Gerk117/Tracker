//
//  TrackerModel.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 14.12.2023.
//

import UIKit

struct TrackerModel {
    let id : UUID
    let name : String
    let colorName : UIColor
    let emoji : String
    let schedule : [WeekDay]
    let isRegular : Bool
    let isPinned : Bool
}
