//
//  Live.swift
//  WorkoutAchievements
//
//  Created by Yurii B on 8/3/23.
//

import Foundation
import WorkoutsClient

extension WorkoutsClient {
    public static let live: WorkoutsClient = .authorizedToReadMock

    public static let actualLiveHealthKitAccess = Self { type in
        let loader = WorkoutLoader()
        let workouts = try await loader.fetchWorkouts(for: type)
        return workouts
    } isAuthorizedToUse: {
        #warning("add")
        return true
    } requestReadAuthorization: {
        try await HealthKitPermissions.requestReadPemissions()
    }
}
