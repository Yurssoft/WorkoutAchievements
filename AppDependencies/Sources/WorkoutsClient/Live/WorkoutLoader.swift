//
//  WorkoutLoader.swift
//  WorkoutAchievements
//
//  Created by Yurii B on 8/5/23.
//

import WorkoutsClient
import HealthKit

final class WorkoutLoader {
    static func fetchData(for query: WorkoutTypeQuery, store: HKHealthStore) async throws -> LoadResult {
        let calorieSummaryStatistic = try await fetchStatistic(store: store, type: .activeEnergyBurned)
        let timeSummaryStatistic = try await fetchStatistic(store: store, type: .appleExerciseTime)
        
        let workouts = try await fetchWorkouts(for: query, store: store)
        
        let loadResult = LoadResult(workouts: workouts,
                                    activeEnergyBurnedStatistic: calorieSummaryStatistic,
                                    timeStatistic: timeSummaryStatistic)
        return loadResult
    }
}

private extension WorkoutLoader {
    static func fetchStatistic(store: HKHealthStore, type: HKQuantityTypeIdentifier) async throws -> Statistic {
        let quantityType = try Helpers.createQuantityType(type: type)
        let statistics = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<HKStatistics, Error>) in
            let query = HKStatisticsQuery(quantityType: quantityType,
                                          quantitySamplePredicate: .none,
                                          completionHandler: statisticsQueryHandler(for: continuation))
            store.execute(query)
        }
        
        let statistic = Statistic(quantity: statistics.sumQuantity(), startDate: statistics.startDate, endDate: statistics.endDate)
        return statistic
    }
    
    static func fetchWorkouts(for query: WorkoutTypeQuery, store: HKHealthStore) async throws -> [Workout] {
        let samples = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            let queryHandler = workoutsQueryHandler(for: continuation)
            let predicates = query.workoutTypes.map { HKQuery.predicateForWorkouts(with: $0) }
            let predicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
            let sort = query.measurmentType.sortDescriptor(isAscending: query.isAscending)
            let searchHKQuery = HKSampleQuery(sampleType: .workoutType(),
                                              predicate: predicate,
                                              limit: HKObjectQueryNoLimit,
                                              sortDescriptors: [sort],
                                              resultsHandler: queryHandler)
            store.execute(searchHKQuery)
        }
        
        guard let workouts = samples as? [HKWorkout] else { return [] }
        let transformed = workouts.map { $0.mapIntoWorkout(for: query) }
        return transformed
    }
    
    static func workoutsQueryHandler(for continuation: CheckedContinuation<[HKSample], Error>) -> (HKQuery, [HKSample]?, Error?) -> Void {
        { _, samples, error in
            if let hasError = error {
                continuation.resume(throwing: hasError)
                return
            }
            
            guard let samples = samples else {
                return continuation.resume(throwing: WorkoutsClientError.fetchingWorkouts)
            }
            
            continuation.resume(returning: samples)
        }
    }
    
    static func statisticsQueryHandler(for continuation: CheckedContinuation<HKStatistics, Error>) -> (HKStatisticsQuery, HKStatistics?, Error?) -> Void {
        { _, statistics, error in
            if let hasError = error {
                continuation.resume(throwing: hasError)
                return
            }
            
            guard let statistics = statistics else {
                return continuation.resume(throwing: WorkoutsClientError.fetchingStatistics)
            }
            
            continuation.resume(returning: statistics)
        }
    }
}

private extension HKWorkout {
    func mapIntoWorkout(for query: WorkoutTypeQuery) -> Workout {
        let healthKitWorkout = self
        let activeEnergy = HKQuantityType(.activeEnergyBurned)
        let activeEnergyStatistics = healthKitWorkout.statistics(for: activeEnergy)
        let sumActiveEnergy = activeEnergyStatistics?.sumQuantity()
        
        let distanceQuantity: HKQuantityType
        switch workoutActivityType {
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
}

private extension WorkoutMeasureType {
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
