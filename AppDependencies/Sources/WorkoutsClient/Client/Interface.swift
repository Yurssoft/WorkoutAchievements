import Foundation
import HealthKit

public enum WorkoutsClientError: Error {
    case fetchingWorkouts
    case fetchingStatistics
    case cannotCreateQuantityType
    case healthKitIsNotAvailable
}

public struct LoadResult {
    public init(workouts: [Workout], activeEnergyBurnedStatistic: Statistic, timeStatistic: Statistic) {
        self.workouts = workouts
        self.activeEnergyBurnedStatistic = activeEnergyBurnedStatistic
        self.timeStatistic = timeStatistic
    }
    
    public let workouts: [Workout]
    public let activeEnergyBurnedStatistic: Statistic
    public let timeStatistic: Statistic
}

public extension WorkoutsClient {
    typealias WorkoutsAndStatisticsDataClosure = (WorkoutTypeQuery) async throws -> LoadResult
    typealias WorkoutsAuthorizationStatusesClosure = () -> AuthorizationSaveStatuses
    typealias RequestReadAuthorizationClosure = () async throws -> Void
    
    typealias WorkoutType = HKWorkoutActivityType
    typealias WorkoutMeasureType = HKQuantityTypeIdentifier
    typealias AuthorizationStatus = HKAuthorizationStatus
}

public struct WorkoutsClient {
    public init(loadWorkoutsAndStatisticsData: @escaping WorkoutsAndStatisticsDataClosure,
                requestReadAuthorization: @escaping RequestReadAuthorizationClosure,
                authorizationStatuses: @escaping WorkoutsAuthorizationStatusesClosure) {
        self.loadWorkoutsAndStatisticsData = loadWorkoutsAndStatisticsData
        self.requestReadAuthorization = requestReadAuthorization
        self.authorizationStatuses = authorizationStatuses
    }
    
    public let loadWorkoutsAndStatisticsData: WorkoutsAndStatisticsDataClosure
    public let requestReadAuthorization: RequestReadAuthorizationClosure
    public let authorizationStatuses: WorkoutsAuthorizationStatusesClosure
}

public struct Workout: Identifiable, Equatable {
    public init(startDate: Date = .now,
                duration: TimeInterval = .pi,
                distanceSumStatisticsQuantity: HKQuantity? = nil,
                activeEnergySumStatisticsQuantity: HKQuantity? = nil,
                query: WorkoutTypeQuery = .init(),
                workoutType: WorkoutsClient.WorkoutType = .walking) {
        self.startDate = startDate
        self.duration = duration
        self.distanceSumStatisticsQuantity = distanceSumStatisticsQuantity
        self.activeEnergySumStatisticsQuantity = activeEnergySumStatisticsQuantity
        self.query = query
        self.workoutType = workoutType
    }
    
    public let id = UUID().uuidString
    public let startDate: Date
    public let duration: TimeInterval
    public let distanceSumStatisticsQuantity: HKQuantity?
    public let activeEnergySumStatisticsQuantity: HKQuantity?
    public let query: WorkoutTypeQuery
    public let workoutType: WorkoutsClient.WorkoutType
}

public extension WorkoutsClient {
    struct AuthorizationSaveStatuses {
        public init(workout: WorkoutsClient.AuthorizationStatus, summary: WorkoutsClient.AuthorizationStatus, route: WorkoutsClient.AuthorizationStatus) {
            self.workout = workout
            self.summary = summary
            self.route = route
        }
        
        public let workout: AuthorizationStatus
        public let summary: AuthorizationStatus
        public let route: AuthorizationStatus
    }
}

public struct Statistic {
    public init(quantity: HKQuantity?, startDate: Date, endDate: Date) {
        self.quantity = quantity
        self.startDate = startDate
        self.endDate = endDate
    }
    
    public let quantity: HKQuantity?
    public let startDate: Date
    public let endDate: Date
}
