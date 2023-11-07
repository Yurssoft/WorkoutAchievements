//
//  WorkoutsStatisticsLoader.swift
//
//
//  Created by Yurii B on 11/7/23.
//

import WorkoutsClient
import HealthKit

final class WorkoutsStatisticsLoader {
    static func fetchStatistic(store: HKHealthStore,
                               type: HKQuantityTypeIdentifier,
                               predicate: NSPredicate) async throws -> Statistic {
        let quantityType = try Helpers.createQuantityType(type: type)
        let statistics = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<HKStatistics, Error>) in
            
            let query = HKStatisticsQuery(quantityType: quantityType,
                                          quantitySamplePredicate: predicate,
                                          completionHandler: statisticsQueryHandler(for: continuation))
            store.execute(query)
        }
        
        let statistic = Statistic(quantity: statistics.sumQuantity(), startDate: statistics.startDate, endDate: statistics.endDate)
        return statistic
    }
    
    static func combinedStatistic(for startDate: Date,
                                  endDate: Date,
                                  statistics: [Statistic],
                                  unit: HKUnit) -> Statistic {
        let statisticsQantity = statistics.compactMap { $0.quantity }
        let statisticsQantityCombined = statisticsQantity.addAllQuantities(unit: unit)
        let summaryStatistic = Statistic(quantity: statisticsQantityCombined, startDate: startDate, endDate: endDate)
        return summaryStatistic
    }
    
    static func statisticsQueryHandler(for continuation: CheckedContinuation<HKStatistics, Error>) -> (HKStatisticsQuery, HKStatistics?, Error?) -> Void {
        { _, statistics, error in
            if let hasError = error {
                continuation.resume(throwing: hasError)
                return
            }
            
            guard let statistics = statistics else {
                return continuation.resume(throwing: WorkoutsClientError.fetchingStatistics)
            }
            
            continuation.resume(returning: statistics)
        }
    }
}

private extension HKQuantity {
    static func add(lhs: HKQuantity, rhs: HKQuantity, unit: HKUnit) -> HKQuantity {
        let value = lhs.doubleValue(for: unit) + rhs.doubleValue(for: unit)
        let added = HKQuantity(unit: unit, doubleValue: value)
        return added
    }
}

private extension Array where Element == HKQuantity {
    func addAllQuantities(unit: HKUnit) -> HKQuantity {
        let initial = HKQuantity(unit: unit, doubleValue: 0)
        let statisticsQantityCombined = self.reduce(initial) { partialResult, quantity in
            let combined = HKQuantity.add(lhs: partialResult, rhs: quantity, unit: unit)
            return combined
        }
        return statisticsQantityCombined
    }
}
