//
//  Shedule.swift
//  Tracker
//
//  Created by Георгий Ксенодохов on 19.01.2024.
//

import Foundation

struct Shedule : Codable  {
    let day: WeekDay
    let isOn: Bool
}

enum WeekDay: Int, CaseIterable , Codable {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
    
    var shortNameDay: String {
        switch self {
        case .monday:
            return NSLocalizedString("Пн", comment: "")
        case .tuesday:
            return NSLocalizedString("Вт", comment: "")
        case .wednesday:
            return NSLocalizedString("Ср", comment: "")
        case .thursday:
            return NSLocalizedString("Чт", comment: "")
        case .friday:
            return NSLocalizedString("Пт", comment: "")
        case .saturday:
            return NSLocalizedString("Сб", comment: "")
        case .sunday:
            return NSLocalizedString("Вс", comment: "")
        }
    }
}
