import Foundation

extension WorkoutsClient {
    public static let workoutsMock = Self { _ in
        [
            Workout(startDate: .now + 500,distanceSumStatisticsQuantity: .init(unit: .meter(), doubleValue: 800)),
            Workout(startDate: .now + 500,distanceSumStatisticsQuantity: .init(unit: .meter(), doubleValue: 500)),
            Workout(startDate: .now + 5,distanceSumStatisticsQuantity: .init(unit: .meter(), doubleValue: 200)),
            Workout(distanceSumStatisticsQuantity: .init(unit: .meter(), doubleValue: 300))
        ]
    } requestReadAuthorization: {
        
    }
}
