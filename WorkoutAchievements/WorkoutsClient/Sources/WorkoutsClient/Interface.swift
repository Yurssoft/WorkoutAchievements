
struct WorkoutsClient {
    public var list: (WorkoutType) async -> [Workout]
}

struct Workout {
    let calories: String
}

enum WorkoutType {
    case swim
    case walk
}
