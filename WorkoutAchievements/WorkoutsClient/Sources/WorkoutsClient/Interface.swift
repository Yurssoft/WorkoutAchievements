import Foundation

public struct WorkoutsClient {
    public init(list: @escaping (WorkoutType) async -> [Workout]) {
        self.list = list
    }
    
    public var list: (WorkoutType) async -> [Workout]
}

public struct Workout: Identifiable {
    public init(calories: String) {
        self.calories = calories
    }
    
    public let id = UUID().uuidString
    public let calories: String
}

public enum WorkoutType {
    case swim
    case walk
}
