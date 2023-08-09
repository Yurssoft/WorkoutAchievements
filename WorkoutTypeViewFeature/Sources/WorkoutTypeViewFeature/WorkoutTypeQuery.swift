//
//  WorkoutTypeQuery.swift
//
//  Created by Yurii B on 8/8/23.
//

import Foundation
import WorkoutsClient

public struct WorkoutTypeQuery {
    var workoutType: WorkoutsClient.WorkoutType
    var displayOrdering: Ordering
}

public enum Ordering {
    case ascending
    case descending
}
