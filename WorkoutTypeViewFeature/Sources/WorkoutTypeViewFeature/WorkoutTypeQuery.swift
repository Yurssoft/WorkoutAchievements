//
//  WorkoutTypeQuery.swift
//
//  Created by Yurii B on 8/8/23.
//

import Foundation
import WorkoutsClient

public struct WorkoutTypeQuery {
    var workoutType = WorkoutsClient.WorkoutType.walking
    var isAscending = false
    var measurmentType = WorkoutMeasureType.distance
}

public enum WorkoutMeasureType {
    case time
    case distance
    case calories
}
