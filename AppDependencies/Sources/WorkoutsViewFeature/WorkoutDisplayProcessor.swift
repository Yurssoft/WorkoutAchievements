//
//  WorkoutDisplayProcessor.swift
//
//  Created by Yurii B on 8/13/23.
//

import Foundation
import WorkoutsClient
import HealthKit

extension Array where Element == Workout {
    func convertToDisplayContainers() -> (displayContainers: [DisplayStringContainer], mostEfficentWorkout: WorkoutEfficiency?) {
        let displayValues = map { $0.displayValues }
        let containers = displayValues.map { $0.displayContainer }
        let efficencies = displayValues.map { $0.workoutEfficiency }.sorted(by: { $0.calorieBurnedPerMinuteEfficiencyOfWorkout > $1.calorieBurnedPerMinuteEfficiencyOfWorkout })
        let mostEfficentWorkout = efficencies.first
        return (containers, mostEfficentWorkout)
    }
}

extension Workout {
    fileprivate var displayValues: WorkoutDispayValues {
        WorkoutDisplayProcessor.process(workout: self)
    }
}

extension WorkoutDispayValues {
    fileprivate var displayContainer: DisplayStringContainer {
        DisplayStringContainer(displayString: displayString)
    }
}

extension WorkoutDispayValues {
    var displayString: String {
        "Calories: \(calories) \nDistance: \(distance)\nTime: \(duration) minutes\nStarted: \(startDate)\nCalories burned per minute efficiency: \(workoutEfficiency.calorieBurnedPerMinuteEfficiencyOfWorkoutDisplayValue)"
    }
}

struct DisplayStringContainer: Identifiable {
    let id = UUID().uuidString
    let displayString: String
}

struct WorkoutEfficiency: Identifiable {
    var id: String {
        workoutId
    }
    
    let workoutId: String
    let calorieBurnedPerMinuteEfficiencyOfWorkout: Int
    let calorieBurnedPerMinuteEfficiencyOfWorkoutDisplayValue: String
}

struct WorkoutDispayValues: Identifiable {
    var id: String {
        workoutId
    }
    
    let workoutId: String
    fileprivate let calories: String
    fileprivate let distance: String
    fileprivate let startDate: String
    fileprivate let duration: String
    fileprivate let type: String
    fileprivate let workoutEfficiency: WorkoutEfficiency
}

final class WorkoutDisplayProcessor {
    static func process(workout: Workout) -> WorkoutDispayValues {
        let date = workout.startDate.mediumDateString()
        let time = DateComponentsFormatter().string(from: workout.duration)!
        
        let caloriesDoubleValue = workout.activeEnergySumStatisticsQuantity?.doubleValue(for: .smallCalorie()) ?? 0
        let stringCalories = caloriesDoubleValue.toString(dimension: UnitEnergy.calories)
        let distanceDouble = workout.distanceSumStatisticsQuantity?.doubleValue(for: .mile()) ?? 0
        let stringDistance = distanceDouble.toString(dimension: UnitLength.miles, digits: 1)
        let durationMinutes = workout.duration.minutes
        let calories = Int(caloriesDoubleValue)
        var calorieBurnedPerMinuteEfficiencyOfWorkout = 0
        if calories > 0, durationMinutes > 0 {
            calorieBurnedPerMinuteEfficiencyOfWorkout = calories / durationMinutes
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        let formatted = formatter.string(from: NSNumber(value: calorieBurnedPerMinuteEfficiencyOfWorkout))
        
        let efficiency = WorkoutEfficiency(workoutId: workout.id,
                                         calorieBurnedPerMinuteEfficiencyOfWorkout: calorieBurnedPerMinuteEfficiencyOfWorkout,
                                         calorieBurnedPerMinuteEfficiencyOfWorkoutDisplayValue: formatted ?? "-")
        
        return WorkoutDispayValues(workoutId: workout.id,
                                   calories: stringCalories,
                                   distance: stringDistance,
                                   startDate: date,
                                   duration: time,
                                   type: "\(workout.workoutType)",
                                   workoutEfficiency: efficiency)
    }
}

extension TimeInterval {
    var minutes: Int {
        (Int(self) / 60 ) % 60
    }
}
