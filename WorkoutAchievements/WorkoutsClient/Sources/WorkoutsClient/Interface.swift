
struct WorkoutsClient {
    public var list: (WorkoutType) async -> [Workout]
}

public struct Workout {
    public let calories: String
}

enum WorkoutType {
    case swim
    case walk
}
