import Foundation
import HealthKit

public typealias Hour = Int

public enum WorkoutsClientError: Error {
    case fetchingWorkouts
    case fetchingStatistics
    case cannotCreateQuantityType
    case healthKitIsNotAvailable
}

public struct LoadResult {
    public init(workouts: [Workout], hours: Hour?, startDate: Date, endDate: Date) {
        self.workouts = workouts
        self.hours = hours
        self.startDate = startDate
        self.endDate = endDate
    }
    
    public let workouts: [Workout]
    public let hours: Hour?
    public let startDate: Date
    public let endDate: Date
}

public extension WorkoutsClient {
    typealias WorkoutsListClosure = (WorkoutTypeQuery) async throws -> [Workout]
    typealias WorkoutsAuthorizationStatusesClosure = () -> AuthorizationSaveStatuses
    typealias RequestReadAuthorizationClosure = () async throws -> Void
    
    typealias WorkoutType = HKWorkoutActivityType
    typealias WorkoutMeasureType = HKQuantityTypeIdentifier
    typealias AuthorizationStatus = HKAuthorizationStatus
}

public struct WorkoutsClient {
    public init(loadWorkoutsList: @escaping WorkoutsListClosure,
                requestReadAuthorization: @escaping RequestReadAuthorizationClosure,
                authorizationStatuses: @escaping WorkoutsAuthorizationStatusesClosure) {
        self.loadWorkoutsList = loadWorkoutsList
        self.requestReadAuthorization = requestReadAuthorization
        self.authorizationStatuses = authorizationStatuses
    }
    
    public let loadWorkoutsList: WorkoutsListClosure
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
