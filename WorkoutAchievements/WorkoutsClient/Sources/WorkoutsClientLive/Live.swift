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
    public static let live: WorkoutsClient = .mock
    public static let actualLiveHealthKitAccess = Self { type in
        switch type {
        case .swim:
            guard HKHealthStore.isHealthDataAvailable() else { return [] }
            let store = HKHealthStore()
            let read: Set = [
                    .workoutType(),
                    HKSeriesType.activitySummaryType(),
                    HKSeriesType.workoutRoute(),
                    HKSeriesType.workoutType()
                ]
            let response: ()? = try? await store.requestAuthorization(toShare: [], read: read)
            guard let response else { return [] }
            let swimming = HKQuery.predicateForWorkouts(with: .swimming)
            let samples = try! await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
                store.execute(HKSampleQuery(sampleType: .workoutType(), predicate: swimming, limit: HKObjectQueryNoLimit,
                                            sortDescriptors: [.init(keyPath: \HKSample.startDate, ascending: false)],
                                            resultsHandler: { _, samples, error in
                    if let hasError = error {
                        continuation.resume(throwing: hasError)
                        return
                    }

                    guard let samples = samples else {
                        fatalError("*** Invalid State: This can only fail if there was an error. ***")
                    }

                    continuation.resume(returning: samples)
                }))
            }

            guard let workouts = samples as? [HKWorkout] else { return [] }
            workouts.map {
                let calories = $0.statistics(for: HKQuantityType(.activeEnergyBurned))
                Workout(calories: calories?.averageQuantity()?.doubleValue(for: .largeCalorie()))
            }
            return workouts
            
        case .walk:
            break
        }
        return []
    }
}
