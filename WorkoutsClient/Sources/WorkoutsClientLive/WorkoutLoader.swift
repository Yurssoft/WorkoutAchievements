//
//  WorkoutLoader.swift
//  WorkoutAchievements
//
//  Created by Yurii B on 8/5/23.
//

import WorkoutsClient
import HealthKit

final class WorkoutLoader {
    private let store = HKHealthStore()
    
    func fetchWorkouts(for type: WorkoutType) async -> [Workout] {
        let samples = try! await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            let queryHandler: (HKSampleQuery, [HKSample]?, Error?) -> Void = { _, samples, error in
                if let hasError = error {
                    continuation.resume(throwing: hasError)
                    return
                }

                guard let samples = samples else {
                    fatalError("*** Invalid State: This can only fail if there was an error. ***")
                }

                continuation.resume(returning: samples)
            }
            let predicate = HKQuery.predicateForWorkouts(with: type)
            let query = HKSampleQuery(sampleType: .workoutType(),
                                      predicate: predicate,
                                      limit: HKObjectQueryNoLimit,
                                      sortDescriptors: [.init(keyPath: \HKSample.startDate, ascending: false)],
                                      resultsHandler: queryHandler)
            store.execute(query)
        }

        guard let workouts = samples as? [HKWorkout] else { return [] }
        let transformed = workouts.map { healthKitWorkout -> Workout in
            let activeEnergy = HKQuantityType(.activeEnergyBurned)
            let caloriesStatistics = healthKitWorkout.statistics(for: activeEnergy)
            let sumCalories = caloriesStatistics?.sumQuantity()
            let caloriesDoubleValue = sumCalories?.doubleValue(for: .largeCalorie()) ?? 0
            let workout = Workout(calories: "\(caloriesDoubleValue)")
            return workout
        }
        return transformed
    }
}
