//
//  DateRangeToDateConverter.swift
//
//
//  Created by Yurii B on 11/5/23.
//

import Foundation
import WorkoutsClient
import HealthKit

extension DateRangeType {
    func convertToDateRangePredicate() -> NSPredicate {
        let date = Date()
        switch self {
        case .allTime:
            return HKQuery.predicateForSamples(withStart: .none, end: .none)
            
        case .day:
            let startDate = date.startOfDay
            let endDate = date.endOfDay
            let today = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
            return today
            
        case .week:
            let startDate = date.startOfWeek
            let endDate = date.endOfWeek
            let week = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
            return week
            
        case .month:
            let startDate = date.startOfMonth
            let endDate = date.endOfMonth
            let month = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
            return month
            
        case .year:
            let startDate = date.startOfYear
            let endDate = date.endOfYear
            let year = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
            return year
            
        case .dateRange(startDate: let startDate, endDate: let endDate):
            let range = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
            return range
            
        case .selectedDates(let dates):
            fatalError()
        }
    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfWeek: Date {
        Calendar.current.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
    
    var endOfWeek: Date {
        var components = DateComponents()
        components.weekOfYear = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfWeek)!
    }
    
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
    
    var startOfYear: Date {
        let components = Calendar.current.dateComponents([.year], from: startOfDay)
        let date = Calendar.current.date(from: components)!
        return date
    }
    
    var endOfYear: Date {
        let year = Calendar.current.component(.year, from: startOfYear)
        // Get the first day of next year
       let firstOfNextYear = Calendar.current.date(from: DateComponents(year: year + 1, month: 1, day: 1))!
        // Get the last day of the current year
        let lastOfYear = Calendar.current.date(byAdding: .day, value: -1, to: firstOfNextYear)!
        return lastOfYear
    }
}
