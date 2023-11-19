//
//  WorkoutLoader.swift
//  WorkoutAchievements
//
//  Created by Yurii B on 8/5/23.
//

import WorkoutsClient
import HealthKit

final class WorkoutLoader {
    static func fetchStatisticsAndWorkouts(for query: WorkoutTypeQuery, store: HKHealthStore) async throws -> LoadResult {
        switch query.dateRangeType {
        case .allTime,
                .day,
                .month,
                .year,
                .week,
                .dateRange:
            return try await fetchData(for: query, store: store)
        case .selectedDates(let dates):
            return try await fetchData(for: dates, query: query, store: store)
        }
    }
}

private extension WorkoutLoader {
    static func fetchData(for dates: [Date],
                          query: WorkoutTypeQuery,
                          store: HKHealthStore) async throws -> LoadResult {
        let resultsPerDate = try await fetchResults(for: dates, query: query, store: store)
        let sortedDates = dates.sorted()
        let startDate = sortedDates.first ?? Date()
        let endDate = sortedDates.last ?? Date()
        
        let energyStatistics = resultsPerDate.map { $0.activeEnergyBurnedStatistic }
        let calorieSummaryStatistic = WorkoutsStatisticsLoader.combinedStatistic(for: startDate,
                                                                                 endDate: endDate,
                                                                                 statistics: energyStatistics,
                                                                                 unit: DefaultUnits.hkCalorieUnit)
        
        let timeStatistics = resultsPerDate.map { $0.timeStatistic }
        let timeSummaryStatistic = WorkoutsStatisticsLoader.combinedStatistic(for: startDate,
                                                                              endDate: endDate,
                                                                              statistics: timeStatistics,
                                                                              unit: .minute())
        
        let workouts = resultsPerDate.map { $0.workouts }.flatMap { $0 }
        let loadResult = LoadResult(workouts: workouts,
                                    activeEnergyBurnedStatistic: calorieSummaryStatistic,
                                    timeStatistic: timeSummaryStatistic)
        return loadResult
    }
    
    static func fetchResults(for dates: [Date], query: WorkoutTypeQuery, store: HKHealthStore) async throws -> [LoadResult] {
        var query = query
        var results = [LoadResult]()
        for date in dates {
            query.dateRangeType = .selectedDates([date])
            let dateResult = try await fetchData(for: query, store: store)
            results.append(dateResult)
        }
        return results
    }
    
    static func fetchData(for query: WorkoutTypeQuery, store: HKHealthStore) async throws -> LoadResult {
        let dateFilterPredicate = query.dateRangeType.convertToDateRangePredicate()
        async let calorieSummaryStatistic = try WorkoutsStatisticsLoader.fetchStatistic(store: store,
                                                                                        type: .activeEnergyBurned,
                                                                                        predicate: dateFilterPredicate)
        async let timeSummaryStatistic = try WorkoutsStatisticsLoader.fetchStatistic(store: store,
                                                                                     type: .appleExerciseTime,
                                                                                     predicate: dateFilterPredicate)
        
        async let workouts = try fetchWorkouts(for: query, store: store, additionalPredicate: dateFilterPredicate)
        let loadResult = await LoadResult(workouts: try workouts,
                                          activeEnergyBurnedStatistic: try calorieSummaryStatistic,
                                          timeStatistic: try timeSummaryStatistic)
        return loadResult
    }
    
    static func fetchWorkouts(for query: WorkoutTypeQuery,
                              store: HKHealthStore,
                              additionalPredicate: NSPredicate) async throws -> [Workout] {
        let samples = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            let queryHandler = workoutsQueryHandler(for: continuation)
            let workoutPredicates = query.workoutTypes.map { HKQuery.predicateForWorkouts(with: $0) }
            let workoutPredicate = NSCompoundPredicate(type: .or, subpredicates: workoutPredicates)
            let predicates = [workoutPredicate, additionalPredicate]
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
            
        case .cycling:
            distanceQuantity = HKQuantityType(.distanceCycling)
            
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
        case .date:
            return .init(key: HKSampleSortIdentifierStartDate, ascending: isAscending)
        }
    }
}

extension NSPredicate: @unchecked Sendable {}
