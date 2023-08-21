//
//  Live.swift
//  WorkoutAchievements
//
//  Created by Yurii B on 8/3/23.
//

import Foundation
import WorkoutsClient
import HealthKit

extension WorkoutsClient {
    static var liveClient = {
        let store = HKHealthStore()
        let permissions = HealthKitPermissions(store: store)
        return Self { type in
            let workouts = try await WorkoutLoader.fetchWorkouts(for: type, store: store)
            return workouts
        } requestReadAuthorization: {
            try await permissions.requestReadPemissions()
        }
    }
    
    public static let live = liveClient()
}
