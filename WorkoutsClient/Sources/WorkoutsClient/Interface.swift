import Foundation
import HealthKit

public struct WorkoutsClient {
    public init(loadWorkoutsList: @escaping (WorkoutType) async -> [Workout],
                  isAuthorizedToUse: @escaping () -> Bool,
                  requestReadAuthorization: @escaping () async throws -> Void) {
        self.loadWorkoutsList = loadWorkoutsList
        self.isAuthorizedToUse = isAuthorizedToUse
        self.requestReadAuthorization = requestReadAuthorization
    }
    
    public var loadWorkoutsList: (WorkoutType) async -> [Workout]
    public var isAuthorizedToUse: () -> Bool
    public var requestReadAuthorization: () async throws -> Void
}

public struct Workout: Identifiable {
    public init(calories: String) {
        self.calories = calories
    }
    
    public let id = UUID().uuidString
    public let calories: String
}


public typealias WorkoutType = HKWorkoutActivityType
