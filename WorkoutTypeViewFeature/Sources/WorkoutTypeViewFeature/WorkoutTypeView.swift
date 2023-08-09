//
//  WorkoutTypeView.swift
//
//  Created by Yurii B on 8/8/23.
//

import SwiftUI

public struct WorkoutTypeView: View {
    @State private var selectedQuery = WorkoutTypeQuery()
    public var body: some View {
        Group {
            VStack {
                Picker("Select Ordering", selection: $selectedQuery.displayOrdering) {
                    ForEach(Ordering.allCases, id: \.self) {
                        Text(String(describing: $0))
                    }
                }
                .pickerStyle(.menu)
                
                Picker("Select Type", selection: $selectedQuery.workoutType) {
                    ForEach(Ordering.allCases, id: \.self) {
                        Text(String(describing: $0))
                    }
                }
                .pickerStyle(.menu)
                
                Text("Selected Query: \(String(describing: selectedQuery.displayOrdering))\n \(String(describing: selectedQuery.workoutType))")
            }
        }
        .padding()
    }
}

#Preview { WorkoutTypeView() }
