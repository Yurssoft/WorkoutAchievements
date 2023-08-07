import Foundation

extension WorkoutsClient {
    public static let authorizedToReadMock = Self { _ in
        [Workout(calories: "1010"), Workout(calories: "1010")]
    } isAuthorizedToUse: {
        true
    } requestReadAuthorization: {
        
    }
}
