import Foundation
import HealthKit
import WorkoutsClient

enum Helpers {
    static func createQuantityType(type: HKQuantityTypeIdentifier) throws -> HKQuantityType {
        guard let quantity = HKObjectType.quantityType(forIdentifier: type) else { throw WorkoutsClientError.cannotCreateQuantityType }
            return quantity
    }
}
