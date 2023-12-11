//
//  WorkoutDisplayProcessor.swift
//
//  Created by Yurii B on 8/13/23.
//

import Foundation
import WorkoutsClient
import HealthKit
import FeatureFlags

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
        DisplayStringContainer(displayString: displayString, workoutId: workoutId, imageName: imageName, type: type)
    }
}

extension WorkoutDispayValues {
    var displayString: String {
        var string = "Calories: \(calories) \nDistance: \(distance)\nTime: \(duration) minutes\nStarted: \(startDate)"
        if FeatureFlags.isDisplayingWorkoutEfficency {
            string += "\nCalories burned per minute efficiency: \(workoutEfficiency.calorieBurnedPerMinuteEfficiencyOfWorkoutDisplayValue)"
        }
        return string
    }
}

struct DisplayStringContainer: Identifiable {
    let id = UUID().uuidString
    let displayString: String
    let workoutId: String
    let imageName: String
    let type: String
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
    fileprivate let imageName: String
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
        
        let caloriesDoubleValue = workout.activeEnergySumStatisticsQuantity?.doubleValue(for: DefaultUnits.hkCalorieUnit) ?? 0
        let stringCalories = caloriesDoubleValue.toString(dimension: DefaultUnits.measurmentCalorieUnit)
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
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        let formatted = formatter.string(from: NSNumber(value: calorieBurnedPerMinuteEfficiencyOfWorkout))
        
        let efficiency = WorkoutEfficiency(workoutId: workout.id,
                                         calorieBurnedPerMinuteEfficiencyOfWorkout: calorieBurnedPerMinuteEfficiencyOfWorkout,
                                         calorieBurnedPerMinuteEfficiencyOfWorkoutDisplayValue: formatted ?? "-")
        
        return WorkoutDispayValues(workoutId: workout.id,
                                   imageName: workout.workoutType.imageName,
                                   calories: stringCalories,
                                   distance: stringDistance,
                                   startDate: date,
                                   duration: time,
                                   type: "\(workout.workoutType.name)",
                                   workoutEfficiency: efficiency)
    }
}

extension TimeInterval {
    var minutes: Int {
        if self <= 3600 {
            (Int(self) / 60 ) % 60
        } else {
            Int(self) / 60
        }
    }
}
