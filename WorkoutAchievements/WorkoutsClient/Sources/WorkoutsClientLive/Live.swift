//
//  Live.swift
//  WorkoutAchievements
//
//  Created by Yurii B on 8/3/23.
//

import Foundation
import WorkoutsClient

extension WorkoutsClient {
    public static let live = Self(list: { type in
        [Workout(calories: "1010"), Workout(calories: "1010")]
    })
}
