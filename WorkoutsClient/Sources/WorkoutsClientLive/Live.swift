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
    public static let live: WorkoutsClient = .authorizedToReadMock
    
    public static var actualLiveHealthKitAccess = {
        let store = HKHealthStore()
        let permissions = HealthKitPermissions(store: store)
        return Self { type in
            let workouts = try await WorkoutLoader.fetchWorkouts(for: type, store: store)
            return workouts
        } isAuthorizedToUse: {
            permissions.isAuthorizedToUse()
        } requestReadAuthorization: {
            try await permissions.requestReadPemissions()
        }
    }
}
