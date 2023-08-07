import Foundation
import HealthKit

public extension WorkoutsClient {
    typealias WorkoutsListClosure = (WorkoutType) async throws -> [Workout]
    typealias IsAuthorizedToUseClosure = () -> Bool
    typealias RequestReadAuthorizationClosure = () async throws -> Void
}

public struct WorkoutsClient {
    public init(loadWorkoutsList: @escaping WorkoutsListClosure,
                isAuthorizedToUse: @escaping IsAuthorizedToUseClosure,
                requestReadAuthorization: @escaping RequestReadAuthorizationClosure) {
        self.loadWorkoutsList = loadWorkoutsList
        self.isAuthorizedToUse = isAuthorizedToUse
        self.requestReadAuthorization = requestReadAuthorization
    }
    
    public var loadWorkoutsList: WorkoutsListClosure
    public var isAuthorizedToUse: IsAuthorizedToUseClosure
    public var requestReadAuthorization: RequestReadAuthorizationClosure
}

public struct Workout: Identifiable {
    public init(calories: String) {
        self.calories = calories
    }
    
    public let id = UUID().uuidString
    public let calories: String
}


public typealias WorkoutType = HKWorkoutActivityType
