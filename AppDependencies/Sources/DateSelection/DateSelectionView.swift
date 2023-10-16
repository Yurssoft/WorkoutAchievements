//
//  DateSelectionView.swift
//  
//
//  Created by Yurii B on 10/15/23.
//

import Foundation
import SwiftUI
import Combine

struct DateSelectionView: View {
    init(viewModel: DateSelectionView.ViewModel) {
        self.viewModel = viewModel
    }
    
    @Bindable private var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Picker("Period", selection: $viewModel.state) {
                ForEach(ViewState.allCases, id: \.self) {
                    Text($0.name)
                        .tag($0)
                }
            }
            .pickerStyle(.navigationLink)
            
            switch viewModel.state {
            case .customDates:
                multipleDatePicker()
                
            case .customRange:
                startEndDate()
                
            default:
                EmptyView()
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func startEndDate() -> some View {
        VStack {
            DatePicker("Start Date", selection: $viewModel.startDate, displayedComponents: [.date, .hourAndMinute])
            DatePicker("End Date", selection: $viewModel.endDate, displayedComponents: [.date, .hourAndMinute])
        }
    }
    
    @ViewBuilder
    func multipleDatePicker() -> some View {
#if os(iOS)
        VStack {
            MultiDatePicker("Dates Available", selection: $viewModel.dates)
        }
#endif
#if os(watchOS)
        EmptyView()
#endif
    }
}

#Preview {
    NavigationStack {
        DateSelectionView(viewModel:
            DateSelectionView.ViewModel(selectedDateRangeType: .allTime)
        )
    }
}
