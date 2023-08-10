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

public struct WorkoutTypeView: View {
    @State private var selectedQuery = WorkoutTypeQuery()
    public var body: some View {
        Group {
            VStack {
                Picker("Select Ordering", selection: $selectedQuery.workoutType) {
                    ForEach(WorkoutsClient.WorkoutType.allCases, id: \.self) {
                        Text($0.name)
                    }
                }
                .pickerStyle(.menu)
                
                
//                HKWorkoutActivityType add menu picker here somehow
//                Picker("Select Type", selection: $selectedQuery.workoutType) {
//                    ForEach(Ordering.allCases, id: \.self) {
//                        Text(String(describing: $0))
//                    }
//                }
//                .pickerStyle(.menu)
                
                Text("Selected Query: \(String(describing: selectedQuery.workoutType))\n \(selectedQuery.workoutType.name)")
            }
        }
        .padding()
    }
}

#Preview { WorkoutTypeView() }
