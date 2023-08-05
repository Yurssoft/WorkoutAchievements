//
//  Live.swift
//  WorkoutAchievements
//
//  Created by Yurii B on 8/3/23.
//

import Foundation
import WorkoutsClient
import HealthKit

final class WorkoutLoader {
    private let workoutReadTypesSet: Set = [
        .workoutType(),
        HKSeriesType.activitySummaryType(),
        HKSeriesType.workoutRoute(),
        HKSeriesType.workoutType()
    ]
    private let store = HKHealthStore()
    
    func fetchWorkouts(for type: WorkoutType) async -> [Workout] {
        guard HKHealthStore.isHealthDataAvailable() else { return [] }
        let response: ()? = try? await store.requestAuthorization(toShare: [], read: workoutReadTypesSet)
        guard let response else { return [] }
        let predicate = HKQuery.predicateForWorkouts(with: type)
        let samples = try! await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            store.execute(HKSampleQuery(sampleType: .workoutType(), predicate: predicate, limit: HKObjectQueryNoLimit,
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
        let transformed = workouts.map { healthKitWorkout -> Workout in
            let activeEnergy = HKQuantityType(.activeEnergyBurned)
            let caloriesStatistics = healthKitWorkout.statistics(for: activeEnergy)
            let averageCalories = caloriesStatistics?.averageQuantity()
            let caloriesDoubleValue = averageCalories?.doubleValue(for: .largeCalorie()) ?? 0
            let workout = Workout(calories: "\(caloriesDoubleValue)")
            return workout
        }
        return transformed
    }
}

extension WorkoutsClient {
    public static let live: WorkoutsClient = .mock
    
    public static let actualLiveHealthKitAccess = Self { type in
        let loader = WorkoutLoader()
        let workouts = await loader.fetchWorkouts(for: type)
        return workouts
    }
}
