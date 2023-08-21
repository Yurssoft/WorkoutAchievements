//
//  Types.swift
//  WorkoutAchievements
//
//  Created by Yurii B on 8/21/23.
//

import WorkoutsClient

enum QueryType {
    case all
    case workoutType(WorkoutsClient.WorkoutType)
    
    var types: WorkoutsClient.WorkoutType {
        switch self {
        case .all:
            return WorkoutsClient.WorkoutType.allCases
            
        case .workoutType(let type):
            return type
        }
    }
    
    var name: String {
        switch self {
        case .workoutType(let type):
            return type.name
            
        case .all:
            return "All Workouts"
        }
    }
}

extension WorkoutsClient.WorkoutType: CaseIterable {
    public static var allCases: [WorkoutsClient.WorkoutType] {
        [.walking, .swimming, .hiking, .cycling, .running]
    }
    
    var name: String {
        switch self {
        case .walking:
            return "Walking"
            
        case .swimming:
            return "Swimming"
            
        case .hiking:
            return "Hiking"
            
        case .cycling:
            return "Cycling"
            
        case .running:
            return "Running"
            
        default:
            return ""
        }
    }
}

extension WorkoutMeasureType {
    var name: String {
        switch self {
        case .time:
            return "Time"
            
        case .distance:
            return "Distance"
            
        case .calories:
            return "Calories"
        }
    }
}
