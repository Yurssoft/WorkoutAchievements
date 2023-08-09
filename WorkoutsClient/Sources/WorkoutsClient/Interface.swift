import Foundation
import HealthKit

public extension WorkoutsClient {
    typealias WorkoutsListClosure = (WorkoutType) async throws -> [Workout]
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
    public init(calories: String) {
        self.calories = calories
    }
    
    public let id = UUID().uuidString
    public let calories: String
}
