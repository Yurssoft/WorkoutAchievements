import Foundation
import HealthKit

extension WorkoutsClient {
    public static let workoutsMock = Self { _ in
        let workoutsArray = try await getWorkouts()
        let threeMonthsAgo = DateComponents(month: -3)
        let startDate = Calendar.current.date(byAdding: threeMonthsAgo, to: .now)!
        
        let activeEnergyBurnedStatistic = Statistic(quantity: HKQuantity(unit: DefaultUnits.hkCalorieUnit, doubleValue: 47289433), startDate: startDate, endDate: .now)
        let timeStatistic = Statistic(quantity: HKQuantity(unit: .hour(), doubleValue: 7748), startDate: startDate, endDate: .now)
        let loadResult = LoadResult(workouts: workouts,
                                    activeEnergyBurnedStatistic: activeEnergyBurnedStatistic,
                                    timeStatistic: timeStatistic)
        return loadResult
        
    } requestReadAuthorization: {
        
    } authorizationStatuses: {
        AuthorizationSaveStatuses(workout: .sharingAuthorized, summary: .sharingAuthorized, route: .sharingAuthorized)
    }
    
    public static let loadingWorkouts = Self { _ in
        let workoutsArray = try await getLoadingWorkoutsMinutes()
        let threeMonthsAgo = DateComponents(month: -3)
        let startDate = Calendar.current.date(byAdding: threeMonthsAgo, to: .now)!
        
        let activeEnergyBurnedStatistic = Statistic(quantity: HKQuantity(unit: DefaultUnits.hkCalorieUnit, doubleValue: 47289433), startDate: startDate, endDate: .now)
        let timeStatistic = Statistic(quantity: HKQuantity(unit: .hour(), doubleValue: 7748), startDate: startDate, endDate: .now)
        let loadResult = LoadResult(workouts: workouts,
                                    activeEnergyBurnedStatistic: activeEnergyBurnedStatistic,
                                    timeStatistic: timeStatistic)
        return loadResult
        
    } requestReadAuthorization: {
        
    } authorizationStatuses: {
        AuthorizationSaveStatuses(workout: .sharingAuthorized, summary: .sharingAuthorized, route: .sharingAuthorized)
    }
    
    public static func errorLoadingWorkouts(error: WorkoutsClientError) -> Self {
        Self { _ in
            throw error
        } requestReadAuthorization: {
            
        } authorizationStatuses: {
            AuthorizationSaveStatuses(workout: .sharingAuthorized, summary: .sharingAuthorized, route: .sharingAuthorized)
        }
    }
}

private extension WorkoutsClient {
    
    static func getLoadingWorkoutsMinutes() async throws -> [Workout] {
        let minutes = 10
        try await Task.sleep(
            until: .now + .seconds(minutes * 60),
            tolerance: .seconds(1),
            clock: .suspending
        )
        return []
    }
    
    static func getWorkouts() async throws -> [Workout] {
        try await Task.sleep(
            until: .now + .seconds(1),
            tolerance: .seconds(1),
            clock: .suspending
        )
        let workoutTask = Task { () -> [Workout] in
            return workouts
        }
        return try! await workoutTask.result.get()
    }
    
    static var workouts: [Workout] {
        var mockWorkouts = [Workout]()
        for indexNumber in 0...10 {
            let i = Double(indexNumber)
            let w = Workout(
                startDate: .now + TimeInterval(indexNumber),
                distanceSumStatisticsQuantity: .init(unit: .meter(), doubleValue: i),
                activeEnergySumStatisticsQuantity: .init(unit: DefaultUnits.hkCalorieUnit, doubleValue: i)
            )
            mockWorkouts.append(w)
        }
        return mockWorkouts
    }
}
