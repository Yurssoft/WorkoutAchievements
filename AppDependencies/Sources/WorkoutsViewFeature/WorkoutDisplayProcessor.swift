//
//  WorkoutDisplayProcessor.swift
//
//  Created by Yurii B on 8/13/23.
//

import Foundation
import WorkoutsClient
import HealthKit

extension Workout {
    var displayValues: WorkoutDispayValues {
        WorkoutDisplayProcessor.process(workout: self)
    }
}

extension WorkoutDispayValues {
    var displayString: String {
        "Calories: \(calories) \nDistance: \(distance)\nTime: \(duration) minutes\nStarted: \(startDate)"
    }
}

extension WorkoutDispayValues {
    var displayContainer: DisplayStringContainer {
        DisplayStringContainer(displayString: displayString)
    }
}

struct DisplayStringContainer: Identifiable {
    let id = UUID().uuidString
    let displayString: String
}

struct WorkoutDispayValues: Identifiable {
    let id: String
    fileprivate let calories: String
    fileprivate let distance: String
    fileprivate let startDate: String
    fileprivate let duration: String
    fileprivate let type: String
}

final class WorkoutDisplayProcessor {
    static func process(workout: Workout) -> WorkoutDispayValues {
        let date = workout.startDate.convert()
        let time = DateComponentsFormatter().string(from: workout.duration)!
        
        let caloriesDoubleValue = workout.activeEnergySumStatisticsQuantity?.doubleValue(for: .smallCalorie()) ?? 0
        let stringCalories = caloriesDoubleValue.convert(dimension: UnitEnergy.calories)
        let distanceDouble = workout.distanceSumStatisticsQuantity?.doubleValue(for: .mile()) ?? 0
        let stringDistance = distanceDouble.convert(dimension: UnitLength.miles, digits: 1)
        
        return WorkoutDispayValues(id: workout.id,
                                   calories: stringCalories,
                                   distance: stringDistance,
                                   startDate: date,
                                   duration: time,
                                   type: "\(workout.workoutType)")
    }
}
