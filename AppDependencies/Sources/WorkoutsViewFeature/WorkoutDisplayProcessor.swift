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
        "Calories: \(largeCalories) \nDistance: \(distance)\nTime: \(duration) minutes\nStarted: \(startDate)\nType: \(type)"
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
    fileprivate let largeCalories: String
    fileprivate let distance: String
    fileprivate let startDate: String
    fileprivate let duration: String
    fileprivate let type: String
}

final class WorkoutDisplayProcessor {
    static func process(workout: Workout) -> WorkoutDispayValues {
        let date = convert(date: workout.startDate)
        let time = DateComponentsFormatter().string(from: workout.duration)!
        
        let caloriesDoubleValue = workout.activeEnergySumStatisticsQuantity?.doubleValue(for: .largeCalorie()) ?? 0
        let stringCalories = Self.convert(dimension: UnitEnergy.calories, value: caloriesDoubleValue)
        
        let distanceDouble = workout.distanceSumStatisticsQuantity?.doubleValue(for: .meter()) ?? 0
        let stringDistance = Self.convert(dimension: UnitLength.meters, value: distanceDouble)
        
        return WorkoutDispayValues(id: workout.id,
                                   largeCalories: stringCalories,
                                   distance: stringDistance,
                                   startDate: date,
                                   duration: time,
                                   type: "\(workout.workoutType)")
    }
    
    private static func convert(dimension: Dimension, value: Double) -> String {
        let measurement = Measurement(value: value, unit: dimension)
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 2
        formatter.numberFormatter.numberStyle = .decimal
        let string = formatter.string(from: measurement)
        return string
    }
    
    static private func convert(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        let date = dateFormatter.string(from: date)
        return date
    }
}
