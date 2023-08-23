import Foundation

extension WorkoutsClient {
    public static let workoutsMock = Self { _ in
        let workoutsArray = try await getWorkouts()
        return workoutsArray
        
    } requestReadAuthorization: {
        
    } authorizationStatuses: {
        AuthorizationSaveStatuses(workout: .sharingAuthorized, summary: .sharingAuthorized, route: .sharingAuthorized)
    }
    
    private static func getWorkouts() async throws -> [Workout] {
        try await Task.sleep(
            until: .now + .seconds(2),
            tolerance: .seconds(1),
            clock: .suspending
        )
        return workouts
    }
    
    private static var workouts: [Workout] {
        [
            Workout(startDate: .now + 500,distanceSumStatisticsQuantity: .init(unit: .meter(), doubleValue: 800)),
            Workout(startDate: .now + 500,distanceSumStatisticsQuantity: .init(unit: .meter(), doubleValue: 500)),
            Workout(startDate: .now + 5,distanceSumStatisticsQuantity: .init(unit: .meter(), doubleValue: 200)),
            Workout(distanceSumStatisticsQuantity: .init(unit: .meter(), doubleValue: 300))
        ]
    }
}
