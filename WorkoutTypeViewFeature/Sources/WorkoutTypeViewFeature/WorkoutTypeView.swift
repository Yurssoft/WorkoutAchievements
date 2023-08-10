//
//  WorkoutTypeView.swift
//
//  Created by Yurii B on 8/8/23.
//

import SwiftUI
import WorkoutsClient

extension WorkoutsClient.WorkoutType: CaseIterable {
    public static var allCases: [WorkoutsClient.WorkoutType] {
        [.walking, .swimming, .hiking]
    }
    
    var name: String {
        switch self {
        case .walking:
            return "Walking"
            
        case .swimming:
            return "Swimming"
            
        case .hiking:
            return "Hiking"
            
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

public struct WorkoutTypeView: View {
    public init() { }
    
    @State private var selectedQuery = WorkoutTypeQuery()
    public var body: some View {
        Group {
            VStack {
                Picker("Workout Type:", selection: $selectedQuery.workoutType) {
                    ForEach(WorkoutsClient.WorkoutType.allCases, id: \.self) {
                        Text($0.name)
                    }
                }
                .pickerStyle(.menu)
                
                Picker("Measurment Type", selection: $selectedQuery.measurmentType) {
                    ForEach(WorkoutMeasureType.allCases, id: \.self) {
                        Text($0.name)
                    }
                }
                .pickerStyle(.menu)
                
                Toggle("Is Ascending", isOn: $selectedQuery.isAscending)
                
                Text("Selected Query:\n \(selectedQuery.measurmentType.name)\n \(selectedQuery.workoutType.name)")
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
}

#Preview { WorkoutTypeView() }
