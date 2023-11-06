//
//  ViewModel.swift
//  
//
//  Created by Yurii B on 10/16/23.
//

import Foundation
import WorkoutsClient
import Combine

extension DateSelectionView {
    @Observable public final class ViewModel {
        public init(selectedDateRangeType: DateRangeType) {
            self.selectedDateRangeType = selectedDateRangeType
            self.state = selectedDateRangeType.toViewState()
            startDate = selectedDateRangeType.startDate
            endDate = selectedDateRangeType.endDate
            dates = Self.datesToComponents(dates: selectedDateRangeType.dates)
        }
        
        public var selectedDateRangeType: DateRangeType
        var state: ViewState
        var dates: Set<DateComponents> = []
        var startDate: Date
        var endDate: Date
        
        func stateChanged() {
            selectedDateRangeType = transformInternalStateToDateRangeType()
        }
    }
}

private extension DateSelectionView.ViewModel {
    static func compoentsToDates(dates: Set<DateComponents>) -> [Date] {
        dates.compactMap { components in
            Calendar.current.date(from: components)
        }
    }
    
    static func datesToComponents(dates: [Date]) -> Set<DateComponents> {
        let calendar = Calendar.current
        let zone = TimeZone.current
        let components = dates.map { calendar.dateComponents(in: zone, from: $0) }
        return Set(components)
    }
    
    func transformInternalStateToDateRangeType() -> DateRangeType {
        switch state {
        case .allTime:
            return .allTime
        case .day:
            return .day
        case .week:
            return .week
        case .month:
            return .month
        case .year:
            return .year
        case .customRange:
            return .dateRange(startDate: startDate, endDate: endDate)
        case .customDates:
            return .selectedDates(Self.compoentsToDates(dates: dates))
        }
    }
}

extension DateRangeType {
    func toViewState() -> DateSelectionView.ViewState {
        switch self {
        case .allTime:
            return .allTime
        case .day:
            return .day
        case .week:
            return .week
        case .month:
            return .month
        case .year:
            return .year
        case .dateRange:
            return .customRange
        case .selectedDates:
            return .customDates
        }
    }
    
    var startDate: Date {
        switch self {
        case let .dateRange(startDate, _):
            return startDate
            
        default:
            return Date()
        }
    }
    
    var endDate: Date {
        switch self {
        case let .dateRange(_, endDate):
            return endDate
            
        default:
            return Date()
        }
    }
    
    var dates: [Date] {
        switch self {
        case .selectedDates(let dates):
            return dates
            
        default:
            return []
        }
    }
}

extension DateSelectionView {
    enum ViewState: CaseIterable, Hashable {
        static var allCases: [Self] {
            [
                .allTime,
                .day,
                .week,
                .month,
                .year,
                .customRange,
                .customDates
            ]
        }
        
        case allTime
        case day
        case week
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
            case .week:
                return "This week"
            case .month:
                return "This month"
            case .year:
                return "This year"
            case .customRange:
                return "Range"
            case .customDates:
                return "Custom dates (Select specific dates)"
            }
        }
    }
}

