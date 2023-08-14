import Foundation

extension WorkoutsClient {
    public static let authorizedToReadMock = Self { _ in
        [
            Workout(startDate: .now + 5,distanceSumStatisticsQuantity: .init(unit: .meter(), doubleValue: 200)),
            Workout(distanceSumStatisticsQuantity: .init(unit: .meter(), doubleValue: 300))
        ]
    } requestReadAuthorization: {
        
    }
}
