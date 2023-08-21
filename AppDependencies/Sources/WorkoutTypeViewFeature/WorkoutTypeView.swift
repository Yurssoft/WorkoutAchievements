//
//  WorkoutTypeView.swift
//
//  Created by Yurii B on 8/8/23.
//

import SwiftUI
import WorkoutsClient

public struct WorkoutTypeView: View {
    public init(selectedQuery: Binding<WorkoutTypeQuery>) {
        self._selectedQuery = selectedQuery
        self.typesQuery = selectedQuery.wrappedValue
    }
    
    @State private var typesQuery: QueryType
    @Binding private var selectedQuery: WorkoutTypeQuery
    public var body: some View {
        VStack {
            Picker("Workout Type:", selection: $selectedQuery.workoutType) {
                ForEach(WorkoutsClient.WorkoutType.allCases, id: \.self) {
                    Text($0.name)
                }
            }
            .pickerStyle(.automatic)
            
            Picker("Measurment Type", selection: $selectedQuery.measurmentType) {
                ForEach(WorkoutMeasureType.allCases, id: \.self) {
                    Text($0.name)
                }
            }
            .pickerStyle(.automatic)
            
            Toggle("Is Ascending", isOn: $selectedQuery.isAscending)
            
            Text("Selected Query:\n \(selectedQuery.measurmentType.name)\n \(selectedQuery.workoutType.name) \n isAscending: \(String(describing: selectedQuery.isAscending))")
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
    }
}

#Preview { WorkoutTypeView(selectedQuery: .constant(.init())) }
