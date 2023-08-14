import Foundation
import HealthKit

public enum WorkoutsClientError: Error {
    case fetchingWorkouts
}

public extension WorkoutsClient {
    typealias WorkoutsListClosure = (WorkoutTypeQuery) async throws -> [Workout]
    typealias RequestReadAuthorizationClosure = () async throws -> Void
    
    typealias WorkoutType = HKWorkoutActivityType
    typealias WorkoutMeasureType = HKQuantityTypeIdentifier
}

public struct WorkoutsClient {
    public init(loadWorkoutsList: @escaping WorkoutsListClosure,
                requestReadAuthorization: @escaping RequestReadAuthorizationClosure) {
        self.loadWorkoutsList = loadWorkoutsList
        self.requestReadAuthorization = requestReadAuthorization
    }
    
    public var loadWorkoutsList: WorkoutsListClosure
    public var requestReadAuthorization: RequestReadAuthorizationClosure
}

public struct Workout: Identifiable {
    public init(startDate: Date = .now,
                duration: TimeInterval = .pi,
                distanceSumStatisticsQuantity: HKQuantity? = nil,
                activeEnergySumStatisticsQuantity: HKQuantity? = nil,
                query: WorkoutTypeQuery = .init()) {
        self.startDate = startDate
        self.duration = duration
        self.distanceSumStatisticsQuantity = distanceSumStatisticsQuantity
        self.activeEnergySumStatisticsQuantity = activeEnergySumStatisticsQuantity
        self.query = query
    }
    
    public let id = UUID().uuidString
    public let startDate: Date
    public let duration: TimeInterval
    public let distanceSumStatisticsQuantity: HKQuantity?
    public let activeEnergySumStatisticsQuantity: HKQuantity?
    public let query: WorkoutTypeQuery
}
