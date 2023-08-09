//
//  WorkoutTypeQuery.swift
//
//  Created by Yurii B on 8/8/23.
//

import Foundation
import WorkoutsClient

public struct WorkoutTypeQuery {
    var workoutType = WorkoutsClient.WorkoutType.walking
    var displayOrdering = Ordering.descending
}

public enum Ordering: CaseIterable {
    case ascending
    case descending
}

