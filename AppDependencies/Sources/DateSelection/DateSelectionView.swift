//
//  DateSelectionView.swift
//  
//
//  Created by Yurii B on 10/15/23.
//

import Foundation
import SwiftUI
import Combine

/// https://developer.apple.com/documentation/swiftui/multidatepicker

enum SelectedDateRangeType: CaseIterable {
    case allTime
    case day
    case month
    case year
    
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
        }
    }
}

extension DateSelectionView {
    @Observable final class ViewModel {
        var selectedDateRangeType: SelectedDateRangeType = .allTime
    }
}

struct DateSelectionView: View {
    init(viewModel: DateSelectionView.ViewModel) {
        self.viewModel = viewModel
    }
    
    @Bindable private var viewModel: ViewModel
    
    var body: some View {
        HStack {
            Text("Date Range ")
            Picker("Date Range:", selection: $viewModel.selectedDateRangeType) {
                Text(SelectedDateRangeType.allTime.name)
                    .tag(SelectedDateRangeType.allTime)
                ForEach(SelectedDateRangeType.allCases, id: \.self) {
                    Text($0.name)
                        .tag($0)
                }
            }
            .pickerStyle(.automatic)
        }
    }
}

#Preview {
    DateSelectionView(viewModel: DateSelectionView.ViewModel())
}
