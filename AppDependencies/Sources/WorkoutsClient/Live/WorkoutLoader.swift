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
        let calorieSummaryStatistic = combinedStatistic(for: startDate,
                                                        endDate: endDate,
                                                        statistics: energyStatistics,
                                                        unit: .smallCalorie())
        
        let timeStatistics = resultsPerDate.map { $0.timeStatistic }
        let timeSummaryStatistic = combinedStatistic(for: startDate,
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
    
    static func combinedStatistic(for startDate: Date,
                                  endDate: Date,
                                  statistics: [Statistic],
                                  unit: HKUnit) -> Statistic {
        let statisticsQantity = statistics.compactMap { $0.quantity }
        let statisticsQantityCombined = statisticsQantity.addAllQuantities(unit: unit)
        let summaryStatistic = Statistic(quantity: statisticsQantityCombined, startDate: startDate, endDate: endDate)
        return summaryStatistic
    }
    
    static func fetchData(for query: WorkoutTypeQuery, store: HKHealthStore) async throws -> LoadResult {
        let dateFilterPredicate = query.dateRangeType.convertToDateRangePredicate()
        let calorieSummaryStatistic = try await fetchStatistic(store: store,
                                                               type: .activeEnergyBurned,
                                                               predicate: dateFilterPredicate)
        let timeSummaryStatistic = try await fetchStatistic(store: store,
                                                            type: .appleExerciseTime,
                                                            predicate: dateFilterPredicate)
        
        let workouts = try await fetchWorkouts(for: query, store: store, additionalPredicate: dateFilterPredicate)
        
        let loadResult = LoadResult(workouts: workouts,
                                    activeEnergyBurnedStatistic: calorieSummaryStatistic,
                                    timeStatistic: timeSummaryStatistic)
        return loadResult
    }
    
    static func fetchStatistic(store: HKHealthStore,
                               type: HKQuantityTypeIdentifier,
                               predicate: NSPredicate) async throws -> Statistic {
        let quantityType = try Helpers.createQuantityType(type: type)
        let statistics = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<HKStatistics, Error>) in
            
            let query = HKStatisticsQuery(quantityType: quantityType,
                                          quantitySamplePredicate: predicate,
                                          completionHandler: statisticsQueryHandler(for: continuation))
            store.execute(query)
        }
        
        let statistic = Statistic(quantity: statistics.sumQuantity(), startDate: statistics.startDate, endDate: statistics.endDate)
        return statistic
    }
    
    static func fetchWorkouts(for query: WorkoutTypeQuery,
                              store: HKHealthStore,
                              additionalPredicate: NSPredicate) async throws -> [Workout] {
        let samples = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            let queryHandler = workoutsQueryHandler(for: continuation)
            var predicates = query.workoutTypes.map { HKQuery.predicateForWorkouts(with: $0) }
            predicates.append(additionalPredicate)
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

private extension HKQuantity {
    static func add(lhs: HKQuantity, rhs: HKQuantity, unit: HKUnit) -> HKQuantity {
        let value = lhs.doubleValue(for: unit) + rhs.doubleValue(for: unit)
        let added = HKQuantity(unit: unit, doubleValue: value)
        return added
    }
}

private extension Array where Element == HKQuantity {
    func addAllQuantities(unit: HKUnit) -> HKQuantity {
        let initial = HKQuantity(unit: unit, doubleValue: 0)
        let statisticsQantityCombined = self.reduce(initial) { partialResult, quantity in
            let combined = HKQuantity.add(lhs: partialResult, rhs: quantity, unit: unit)
            return combined
        }
        return statisticsQantityCombined
    }
}
