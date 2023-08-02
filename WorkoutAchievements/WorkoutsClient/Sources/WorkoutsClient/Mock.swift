import Foundation

extension WorkoutsClient {
    public static let mock = Self(list: { type in
        [Workout(calories: "1010"), Workout(calories: "1010")]
    })
}
