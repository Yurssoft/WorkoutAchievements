//
//  DateSelectionView.swift
//  
//
//  Created by Yurii B on 10/15/23.
//

import Foundation
import SwiftUI
import Combine

enum SelectedDateRangeType {
    case allTime
    case dateRange(startDate: Date, endDate: Date)
    case selectedDates([Date])
}

extension DateSelectionView {
    enum ViewState: CaseIterable, Hashable {
        static var allCases: [Self] {
            [
                .allTime,
                .day,
                .month,
                .year,
                .customRange,
                .customDates
            ]
        }
        
        case allTime
        case day
        case month
        case year
        case customRange
        case customDates
        
        var name: String {
            switch self {
            case .allTime:
                return "All time"
            case .day:
                return "This day"
            case .month:
                return "This month"
            case .year:
                return "This year"
            case .customRange:
                return "Range"
            case .customDates:
                return "Custom dates"
            }
        }
    }
}

extension DateSelectionView {
    @Observable final class ViewModel {
        fileprivate var state: ViewState = .allTime
    }
}

struct DateSelectionView: View {
    init(viewModel: DateSelectionView.ViewModel) {
        self.viewModel = viewModel
    }
    
    @Bindable private var viewModel: ViewModel
    @State private var dates: Set<DateComponents> = []
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    var body: some View {
        VStack {
            Picker("Period", selection: $viewModel.state) {
                ForEach(ViewState.allCases, id: \.self) {
                    switch $0 {
                    case .customDates:
                        multipleDatePicker(stateName: $0.name)
                        .tag($0)
                        
                    case .customRange:
                        startEndDate(stateName: $0.name)
                            .tag($0)
                        
                    case .allTime:
                        Text($0.name)
                            .tag($0)
                    case .day:
                        Text($0.name)
                            .tag($0)
                    case .month:
                        Text($0.name)
                            .tag($0)
                    case .year:
                        Text($0.name)
                            .tag($0)
                    }
                }
            }
            .pickerStyle(.navigationLink)
        }
        .padding()
    }
    
    @ViewBuilder
    func startEndDate(stateName: String) -> some View {
        VStack {
            Text(stateName)
            DatePicker("Start Date", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
            DatePicker("End Date", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
        }
    }
    
    @ViewBuilder
    func multipleDatePicker(stateName: String) -> some View {
#if os(iOS)
        VStack {
            Text(stateName)
            MultiDatePicker("Dates Available", selection: $dates)
        }
#endif
#if os(watchOS)
        EmptyView()
#endif
    }
}

#Preview {
    NavigationStack {
        DateSelectionView(viewModel: DateSelectionView.ViewModel())
    }
}
