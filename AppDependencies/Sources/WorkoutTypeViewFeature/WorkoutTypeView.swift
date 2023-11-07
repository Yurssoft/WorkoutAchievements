//
//  WorkoutTypeView.swift
//
//  Created by Yurii B on 8/8/23.
//

import SwiftUI
import WorkoutsClient
import DateSelection

public extension WorkoutTypeView {
    @Observable final class ViewModel {
        public init(selectedQuery: WorkoutTypeQuery) {
            self.selectedQuery = selectedQuery
            self.typesQuery = selectedQuery.queryType
            self.dateRangeViewModel = DateSelectionView.ViewModel(selectedDateRangeType: selectedQuery.dateRangeType)
        }
        
        public var selectedQuery: WorkoutTypeQuery
        fileprivate var typesQuery: QueryType
        fileprivate var dateRangeViewModel: DateSelectionView.ViewModel
        
        func typesQueryChanged() {
            selectedQuery = typesQuery.workoutTypeQuery(isAscending: selectedQuery.isAscending,
                                                        measurmentType: selectedQuery.measurmentType,
                                                        dateRangeType: dateRangeViewModel.selectedDateRangeType)
        }
    }
}

public struct WorkoutTypeView: View {
    public init(viewModel: WorkoutTypeView.ViewModel) {
        self.viewModel = viewModel
    }
    
    @Bindable private var viewModel: ViewModel
    
    public var body: some View {
        VStack {
            HStack {
                Text("Display Achivements For ")
                Picker("Workout Type:", selection: $viewModel.typesQuery) {
                    Text(QueryType.all.name)
                        .tag(QueryType.all)
                    ForEach(WorkoutsClient.WorkoutType.allCases, id: \.self) {
                        Text($0.name)
                            .tag(QueryType.workoutTypes([$0]))
                    }
                }
                .pickerStyle(.automatic)
            }
            
            HStack {
                Text("Sort By ")
                Picker("Measurment Type", selection: $viewModel.selectedQuery.measurmentType) {
                    ForEach(WorkoutMeasureType.allCases, id: \.self) {
                        Text($0.name)
                    }
                }
                .pickerStyle(.automatic)
            }
            
            DateSelectionView(viewModel: viewModel.dateRangeViewModel)
            
            HStack {
                Spacer()
                Toggle("Is Ascending", isOn: $viewModel.selectedQuery.isAscending)
                Spacer()
            }
            Spacer()
        }
        .padding()
        .onChange(of: viewModel.typesQuery, viewModel.typesQueryChanged)
        .onChange(of: viewModel.dateRangeViewModel.selectedDateRangeType, viewModel.typesQueryChanged)
    }
}

#Preview {
    NavigationStack {
        WorkoutTypeView(
            viewModel: WorkoutTypeView.ViewModel(
                selectedQuery: WorkoutTypeQuery(
                    workoutTypes: WorkoutsClient.WorkoutType.allCases
                )
            )
        )
    }
}
