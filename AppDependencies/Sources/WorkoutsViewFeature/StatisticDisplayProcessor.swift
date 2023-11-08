//
//  StatisticDisplayProcessor.swift
//  
//
//  Created by Yurii B on 10/10/23.
//

import Foundation
import HealthKit
import WorkoutsClient

extension Statistic {
    var displayCaloriesValues: StatisticDispayValues {
        StatisticDisplayProcessor.processActiveEnergy(statistic: self)
    }
    
    var displayTimeValues: StatisticDispayValues {
        StatisticDisplayProcessor.processTime(statistic: self)
    }
}

struct StatisticDispayValues {
    let value: String
    let startDate: String
    let endDate: String
    let interval: String
}

final class StatisticDisplayProcessor {
    static func processActiveEnergy(statistic: Statistic) -> StatisticDispayValues {
        let caloriesDoubleValue = statistic.quantity?.doubleValue(for: .smallCalorie()) ?? 0
        let stringCalories = caloriesDoubleValue.toString(dimension: UnitEnergy.calories)
        
        return statistic.displayValues(value: stringCalories)
    }
    
    static func processTime(statistic: Statistic) -> StatisticDispayValues {
        let hours = statistic.quantity?.doubleValue(for: .hour()) ?? 0
        return statistic.displayValues(value: "\(Int(hours))")
    }
}

extension Statistic {
    func displayValues(value: String) -> StatisticDispayValues {
        let start = startDate.shortDateString()
        let end = endDate.shortDateString()
        let daysElapsed = Calendar.current.dateComponents([.day], from: startDate, to: endDate)
        return StatisticDispayValues(value: value, startDate: start, endDate: end, interval: "\(daysElapsed.day ?? 0)")
    }
}
