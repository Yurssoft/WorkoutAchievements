//
//  WorkoutTypeQuery.swift
//
//  Created by Yurii B on 8/8/23.
//

import Foundation
import HealthKit

public struct WorkoutTypeQuery: Equatable, Codable {
    public init(workoutTypes: [WorkoutsClient.WorkoutType] = [WorkoutsClient.WorkoutType.walking],
                isAscending: Bool = false,
                measurmentType: WorkoutMeasureType = WorkoutMeasureType.distance,
                dateRangeType: DateRangeType = .allTime) {
        self.workoutTypes = workoutTypes
        self.isAscending = isAscending
        self.measurmentType = measurmentType
        self.dateRangeType = dateRangeType
    }
    
    public var workoutTypes: [WorkoutsClient.WorkoutType]
    public var isAscending: Bool
    public var measurmentType: WorkoutMeasureType
    public var dateRangeType: DateRangeType
}

public enum WorkoutMeasureType: CaseIterable, Equatable, Codable {
    case time
    case distance
    case calories
}

public enum DateRangeType: Equatable, Codable {
    case allTime
    case day
    case month
    case year
    case dateRange(startDate: Date, endDate: Date)
    case selectedDates([Date])
}

extension WorkoutsClient.WorkoutType: Codable { }
