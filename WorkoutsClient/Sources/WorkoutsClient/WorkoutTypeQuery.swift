//
//  WorkoutTypeQuery.swift
//
//  Created by Yurii B on 8/8/23.
//

import Foundation
import HealthKit

#warning("add all types possibility to look, across all workout types")
public struct WorkoutTypeQuery: Equatable {
    public init(workoutType: WorkoutsClient.WorkoutType = WorkoutsClient.WorkoutType.walking,
                isAscending: Bool = false,
                measurmentType: WorkoutMeasureType = WorkoutMeasureType.distance) {
        self.workoutType = workoutType
        self.isAscending = isAscending
        self.measurmentType = measurmentType
    }
    
    public var workoutType: WorkoutsClient.WorkoutType
    public var isAscending: Bool
    public var measurmentType: WorkoutMeasureType
}

public enum WorkoutMeasureType: CaseIterable, Equatable {
    case time
    case distance
    case calories
}
