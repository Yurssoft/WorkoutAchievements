//
//  WorkoutDisplayProcessor.swift
//
//  Created by Yurii B on 8/13/23.
//

import Foundation
import WorkoutsClient
import HealthKit

struct WorkoutDispayValues {
    let largeCalories: Double
    let distance: Double
    let startDate: String
    let duration: String
}

final class WorkoutDisplayProcessor {
    static func process(workout: Workout) -> WorkoutDispayValues {
        let date = convert(date: workout.startDate)
        let time = DateComponentsFormatter().string(from: workout.duration)!
        let caloriesDoubleValue = workout.activeEnergySumStatisticsQuantity?.doubleValue(for: .largeCalorie()) ?? 0
        #warning("use generic value instead of .meter()")
        let distance = workout.distanceSumStatisticsQuantity?.doubleValue(for: .meter()) ?? 0
        return WorkoutDispayValues(largeCalories: caloriesDoubleValue.roundedTo(),
                                   distance: distance.roundedTo(),
                                   startDate: date,
                                   duration: time)
    }
    
    static private func convert(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        let date = dateFormatter.string(from: date)
        return date
    }
}

private extension Double {
    func roundedTo(places: Int = 2) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
