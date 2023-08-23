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
    private let workoutReadTypesSet: Set = [
        HKSeriesType.workoutType(),
        HKSeriesType.activitySummaryType(),
        HKSeriesType.workoutRoute()
    ]
    
    func authorizationStatuses() -> WorkoutsClient.AuthorizationSaveStatuses {
        WorkoutsClient.AuthorizationSaveStatuses(
            workout: store.authorizationStatus(for: HKSeriesType.workoutType()),
            summary: store.authorizationStatus(for: HKSeriesType.activitySummaryType()),
            route: store.authorizationStatus(for: HKSeriesType.workoutRoute())
        )
    }
    
    func requestReadPemissions() async throws {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        try await store.requestAuthorization(toShare: [], read: workoutReadTypesSet)
    }
}
