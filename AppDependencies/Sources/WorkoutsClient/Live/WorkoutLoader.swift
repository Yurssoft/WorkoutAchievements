//
//  WorkoutLoader.swift
//  WorkoutAchievements
//
//  Created by Yurii B on 8/5/23.
//

import WorkoutsClient
import HealthKit

final class WorkoutLoader {
    
    /// https://developer.apple.com/documentation/healthkit/queries/executing_statistics_collection_queries
    /// https://www.devfright.com/the-healthkit-hkstatisticsquery/
    /// - Parameters:
    ///   - predicate: <#predicate description#>
    ///   - store: <#store description#>
    static func fetchWeekStatistics(predicate: NSPredicate, store: HKHealthStore) throws {
        if true {
            return
        }
        let calendar = Calendar.current


        // Create a 1-week interval.
        let interval = DateComponents(day: 7)


        // Set the anchor for 3 a.m. on Monday.
        var components = DateComponents(calendar: calendar,
                                        timeZone: calendar.timeZone,
                                        hour: 3,
                                        minute: 0,
                                        second: 0,
                                        weekday: 2)


        guard let anchorDate = calendar.nextDate(after: Date(),
                                                 matching: components,
                                                 matchingPolicy: .nextTime,
                                                 repeatedTimePolicy: .first,
                                                 direction: .backward) else {
            fatalError("*** unable to find the previous Monday. ***")
        }
        
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            fatalError("*** Unable to create a step count type ***")
        }


        // Create the query.
        let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                quantitySamplePredicate: nil,
                                                options: .cumulativeSum,
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        
        query.initialResultsHandler = {
            query, results, error in
            
            // Handle errors here.
            if let error = error as? HKError {
                switch (error.code) {
                case .errorDatabaseInaccessible:
                    // HealthKit couldn't access the database because the device is locked.
                    return
                default:
                    // Handle other HealthKit errors here.
                    return
                }
            }
            
            guard let statsCollection = results else {
                // You should only hit this case if you have an unhandled error. Check for bugs
                // in your code that creates the query, or explicitly handle the error.
                assertionFailure("")
                return
            }
            let endDate = Date()
            // Plot the weekly step counts over the past 3 months.
              let threeMonthsAgo = DateComponents(month: -3)
              
              guard let startDate = calendar.date(byAdding: threeMonthsAgo, to: endDate) else {
                  fatalError("*** Unable to calculate the start date ***")
              }
              
              // Plot the weekly step counts over the past 3 months.
//              var weeklyData = MyWeeklyData()
              
              // Enumerate over all the statistics objects between the start and end dates.
              statsCollection.enumerateStatistics(from: startDate, to: endDate)
              { (statistics, stop) in
                  if let quantity = statistics.sumQuantity() {
                      let date = statistics.startDate
                      let value = quantity.doubleValue(for: .count())
                      print(value)
                      // Extract each week's data.
//                      weeklyData.addWeek(date: date, stepCount: Int(value))
                  }
              }
              
              // Dispatch to the main queue to update the UI.
//              DispatchQueue.main.async {
//                  myUpdateGraph(weeklyData: weeklyData)
//              }
          }
        store.execute(query)
    }
    
    
//    static func fetchStatistics(predicate: NSPredicate, store: HKHealthStore) throws {
//        HKObjectType.quantityType(forIdentifier: .appleExerciseTime)
//        guard let quantityType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
//            fatalError("*** Unable to create a step count type ***")
//        }
//        let now = Date()
//        let startOfDay = Calendar.current.startOfDay(for: now)
//        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
//        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: .none) { _, statistics, error in
//            if let quantity = statistics?.sumQuantity() {
//                let value = quantity.doubleValue(for: .largeCalorie())
//                print(value)
//            }
//        }
//        store.execute(query)
//    }
    
    private static func fetchStatistic(store: HKHealthStore, type: HKQuantityTypeIdentifier) async throws -> Statistic {
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
    
    static func fetchData(for query: WorkoutTypeQuery, store: HKHealthStore) async throws -> LoadResult {
        let calorieStatistic = try await fetchStatistic(store: store, type: .activeEnergyBurned)
        let timeStatistic = try await fetchStatistic(store: store, type: .appleExerciseTime)
        let workouts = try await fetchWorkouts(for: query, store: store)
        
        let loadResult = LoadResult(workouts: workouts,
                                    activeEnergyBurnedStatistic: calorieStatistic,
                                    timeStatistic: timeStatistic)
        return loadResult
    }
    
    
    static func fetchWorkouts(for query: WorkoutTypeQuery, store: HKHealthStore) async throws -> [Workout] {
        
        let samples = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            let queryHandler = workoutsQueryHandler(for: continuation)
            let predicates = query.workoutTypes.map { HKQuery.predicateForWorkouts(with: $0) }
            let predicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
            try? fetchWeekStatistics(predicate: predicate, store: store)
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
}

private extension WorkoutLoader {
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
