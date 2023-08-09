//
//  HealthKitPermissions.swift
//  WorkoutAchievements
//
//  Created by Yurii B on 8/7/23.
//

import Foundation
import HealthKit

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
    
    func isAuthorizedToUse() -> HKAuthorizationStatus {
        store.authorizationStatus(for: .workoutType())
    }
    
    func requestReadPemissions() async throws {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        try await store.requestAuthorization(toShare: [], read: workoutReadTypesSet)
    }
}
