//
//  HealthKitPermissions.swift
//  WorkoutAchievements
//
//  Created by Yurii B on 8/7/23.
//

import Foundation
import HealthKit

final class HealthKitPermissions {
    private static let workoutReadTypesSet: Set = [
        HKSeriesType.workoutType(),
        HKSeriesType.activitySummaryType(),
        HKSeriesType.workoutRoute()
    ]
    
    static func requestReadPemissions() async throws {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        let authorization = try await HKHealthStore().requestAuthorization(toShare: [], read: Self.workoutReadTypesSet)
    }
}
