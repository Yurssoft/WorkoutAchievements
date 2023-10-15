//
//  Types.swift
//  WorkoutAchievements
//
//  Created by Yurii B on 8/21/23.
//

import WorkoutsClient

enum QueryType: Codable, CaseIterable, Hashable {
    static var allCases: [QueryType] {
        [.all, .workoutTypes(WorkoutsClient.WorkoutType.allCases)]
    }
    
    case all
    case workoutTypes([WorkoutsClient.WorkoutType])
    
    var types: [WorkoutsClient.WorkoutType] {
        switch self {
        case .all:
            return WorkoutsClient.WorkoutType.allCases
            
        case .workoutTypes(let types):
            return types
        }
    }
}

extension QueryType {
    func workoutTypeQuery(isAscending: Bool, measurmentType: WorkoutMeasureType) -> WorkoutTypeQuery {
        let workoutTypes: [WorkoutsClient.WorkoutType]
        switch self {
        case .all:
            workoutTypes = WorkoutsClient.WorkoutType.allCases
        case .workoutTypes(let types):
            workoutTypes = types
        }
        return WorkoutTypeQuery(workoutTypes: workoutTypes, isAscending: isAscending, measurmentType: measurmentType)
    }
}

extension WorkoutTypeQuery {
    var queryType: QueryType {
        if workoutTypes == WorkoutsClient.WorkoutType.allCases {
            return .all
        } else {
            return .workoutTypes(workoutTypes)
        }
    }
}

extension WorkoutsClient.WorkoutType: CaseIterable {
    public static var allCases: [WorkoutsClient.WorkoutType] {
        [.walking, .swimming, .hiking, .cycling, .running]
    }
}

extension QueryType {
    var name: String {
        switch self {
        case .workoutTypes(let workouts):
            return workouts.first?.name ?? "No name"
            
        case .all:
            return "All Workouts"
        }
    }
}

extension WorkoutsClient.WorkoutType {
    
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
