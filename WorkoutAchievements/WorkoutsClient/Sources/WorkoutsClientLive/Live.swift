//
//  Live.swift
//  WorkoutAchievements
//
//  Created by Yurii B on 8/3/23.
//

import Foundation
import WorkoutsClient

extension WorkoutsClient {
    public static let live: WorkoutsClient = .mock
    
    public static let actualLiveHealthKitAccess = Self { type in
        let loader = WorkoutLoader()
        let workouts = await loader.fetchWorkouts(for: type)
        return workouts
    }
}
