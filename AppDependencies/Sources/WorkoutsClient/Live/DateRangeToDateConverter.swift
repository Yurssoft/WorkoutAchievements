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
            let date = dates.first ?? Date()
            let singleRange = HKQuery.predicateForSamples(withStart: date.startOfDay, end: date.endOfDay)
            return singleRange
        }
    }
}
