//
//  HealthKitPermissions.swift
//  WorkoutAchievements
//
//  Created by Yurii B on 8/7/23.
//

import Foundation
import HealthKit
import WorkoutsClient

final class HealthKitPermissions {
    init(store: HKHealthStore) {
        self.store = store
    }
    
    private let store: HKHealthStore
    func authorizationStatuses() -> WorkoutsClient.AuthorizationSaveStatuses {
        WorkoutsClient.AuthorizationSaveStatuses(
            workout: store.authorizationStatus(for: HKSeriesType.workoutType()),
            summary: store.authorizationStatus(for: HKSeriesType.activitySummaryType()),
            route: store.authorizationStatus(for: HKSeriesType.workoutRoute())
        )
    }
    
    func requestReadPemissions() async throws {
        guard HKHealthStore.isHealthDataAvailable() else { throw WorkoutsClientError.healthKitIsNotAvailable }
        let workoutReadTypes = try Self.workoutReadTypesSet()
        try await store.requestAuthorization(toShare: [], read: workoutReadTypes)
    }
    
    private static func workoutReadTypesSet() throws -> Set<HKObjectType> {
        [
            HKSeriesType.workoutType(),
            try Helpers.createQuantityType(type: .activeEnergyBurned),
            try Helpers.createQuantityType(type: .appleExerciseTime),
            HKSeriesType.activitySummaryType(),
            HKSeriesType.workoutRoute()
        ]
    }
}
