//
//  WorkoutLoader.swift
//  WorkoutAchievements
//
//  Created by Yurii B on 8/5/23.
//

import WorkoutsClient
import HealthKit

final class WorkoutLoader {
    
    static func fetchWorkouts(for query: WorkoutTypeQuery, store: HKHealthStore) async throws -> [Workout] {
        let samples = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            let queryHandler: (HKSampleQuery, [HKSample]?, Error?) -> Void = { _, samples, error in
                if let hasError = error {
                    continuation.resume(throwing: hasError)
                    return
                }

                guard let samples = samples else {
                    return continuation.resume(throwing: WorkoutsClientError.fetchingWorkouts)
                }

                continuation.resume(returning: samples)
            }
            let predicate = HKQuery.predicateForWorkouts(with: query.workoutType)
            let sort = query.measurmentType.sortDescriptor(isAscending: query.isAscending)
            let HKQuery = HKSampleQuery(sampleType: .workoutType(),
                                        predicate: predicate,
                                        limit: HKObjectQueryNoLimit,
                                        sortDescriptors: [sort],
                                        resultsHandler: queryHandler)
            store.execute(HKQuery)
        }

        guard let workouts = samples as? [HKWorkout] else { return [] }
        let transformed = workouts.map { healthKitWorkout -> Workout in
            let activeEnergy = HKQuantityType(.activeEnergyBurned)
            let activeEnergyStatistics = healthKitWorkout.statistics(for: activeEnergy)
            let sumActiveEnergy = activeEnergyStatistics?.sumQuantity()
            
            let distanceQuantity: HKQuantityType
            switch query.workoutType {
            case .swimming:
                distanceQuantity = HKQuantityType(.distanceSwimming)
                
            case .walking, .hiking, .running:
                distanceQuantity = HKQuantityType(.distanceWalkingRunning)
                
            default:
                distanceQuantity = HKQuantityType(.appleExerciseTime)
            }
            let statisticDistance = healthKitWorkout.statistics(for: distanceQuantity)?.sumQuantity()
            
        
            let workout = Workout(startDate: healthKitWorkout.startDate,
                                  duration: healthKitWorkout.duration,
                                  distanceSumStatisticsQuantity: statisticDistance,
                                  activeEnergySumStatisticsQuantity: sumActiveEnergy,
                                  query: query)
            return workout
        }
        return transformed
    }
}

extension WorkoutMeasureType {
    func sortDescriptor(isAscending: Bool) -> NSSortDescriptor {
        switch self {
        case .time:
            return .init(key: HKWorkoutSortIdentifierDuration, ascending: isAscending)
        case .distance:
            return .init(key: HKWorkoutSortIdentifierTotalDistance, ascending: isAscending)
        case .calories:
            return .init(key: HKWorkoutSortIdentifierTotalEnergyBurned, ascending: isAscending)
        }
    }
}
