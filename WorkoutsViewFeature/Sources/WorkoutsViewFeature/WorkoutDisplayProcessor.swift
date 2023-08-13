//
//  WorkoutDisplayProcessor.swift
//
//  Created by Yurii B on 8/13/23.
//

import Foundation

final class WorkoutDisplayProcessor {
    static func process(workout: Worout) -> String {
        
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            let date = dateFormatter.string(from: healthKitWorkout.startDate)
        
        
        let time = DateComponentsFormatter().string(from: healthKitWorkout.duration)!
        
        let workout = Workout(calories: "Calories: \(caloriesDoubleValue.roundedTo())\nDistance: \(distance.roundedTo())\nTime: \(time)\nDate: \(date)")
        
        
        let distance = statisticDistance?.doubleValue(for: .meter()) ?? 0
        
        let caloriesDoubleValue = sumCalories?.doubleValue(for: .largeCalorie()) ?? 0
        return ""
    }
}

extension Double {
    func roundedTo(places: Int = 2) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
