//
//  DateSelectionView.swift
//  
//
//  Created by Yurii B on 10/15/23.
//

import Foundation
import SwiftUI
import Combine


extension DateSelectionView {
    enum SelectedDateRangeType: CaseIterable, Hashable {
        static var allCases: [Self] {
            [
                .allTime,
                .day,
                .month,
                .year,
                .customRange(startDate: thisMonthStartDate(), endDate: Date()),
                .customDates([Date()])
            ]
        }
        
        static func thisMonthStartDate() -> Date {
            Date()
        }
        
        case allTime
        case day
        case month
        case year
        case customRange(startDate: Date, endDate: Date)
        case customDates([Date])
        
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
            case .customRange(startDate: let startDate, endDate: let endDate):
                return "\(startDate) \(endDate)"
            case .customDates:
                return "Custom dates"
            }
        }
    }
}

extension DateSelectionView {
    @Observable final class ViewModel {
        var selectedDateRangeType: SelectedDateRangeType = .customRange(startDate: Date(), endDate: Date())
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
            Picker("Date Range:", selection: $viewModel.selectedDateRangeType) {
                ForEach(SelectedDateRangeType.allCases, id: \.self) {
                    Text($0.name)
                        .tag($0)
                }
            }
            .pickerStyle(.navigationLink)
            if case let .customRange(startDate, endDate) = viewModel.selectedDateRangeType {
                multipleDatePicker()
            }
            DatePicker("Start Date", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
            DatePicker("End Date", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
        }
        .padding()
    }
        
    @ViewBuilder
    func multipleDatePicker() -> some View {
#if os(iOS)
        MultiDatePicker("Dates Available", selection: $dates)
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
