//
//  AchievementsView.swift
//  WorkoutAchievements
//
//  Created by Yurii B on 8/1/23.
//

import SwiftUI
import UIKit
import RequestPermissionsViewFeature
import WorkoutsClient
import WorkoutTypeViewFeature
import InformationView

extension AchievementsView {
    enum ViewState {
        case initial
        case view
    }
}

public struct AchievementsView: View {
    public init(workoutsClient: WorkoutsClient, isDisplayingContactInfo: Bool? = nil) {
        self.workoutsClient = workoutsClient
        let lastSavedQuery = QuerySaver.loadLastQuery()
        let viewModelObj = WorkoutTypeView.ViewModel(selectedQuery: lastSavedQuery,
                                                     isDisplayingContactInfo: isDisplayingContactInfo)
        viewModel = viewModelObj
    }
    
    private let workoutsClient: WorkoutsClient
    @Bindable private var viewModel: WorkoutTypeView.ViewModel
    @State private var state = ViewState.initial
    
    public var body: some View {
        ScrollView {
            switch state {
            case .initial:
                EmptyView()
                
            case .view:
                VStack {
                    WorkoutTypeView(viewModel: viewModel)
                    Divider().overlay(Color.gray)
                    RequestPermissionsView(workoutsClient: workoutsClient, selectedQuery: $viewModel.selectedQuery)
                    Spacer()
                }
            }
        }
        .onChange(of: viewModel.selectedQuery, { _, newValue in
            QuerySaver.save(query: newValue)
        })
        .sheet(item: $viewModel.contactInfo) { info in
            NavigationStack {
                InformationView {
                    viewModel.contactInfo = .none
                }
            }
        }
        .navigationTitle("Achievements")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    viewModel.contactInfo = WorkoutTypeView.ViewModel.ContactInfoModel(isDisplayingContactInfo: true)
                } label: {
                    Image(systemName: "info.circle")
                        .tint(.blue)
                }
            }
        }
        .task {
            Task {
                try await Task.sleep(nanoseconds: 770_000_000)
                await switchStateToVivew()
            }
        }
    }
    
    @MainActor
    func switchStateToVivew() async {
        state = .view
    }
}

#Preview {
    NavigationStack {
        UIElementPreview(
            AchievementsView(workoutsClient: .workoutsMock, isDisplayingContactInfo: .none)
        )
    }
}

struct UIElementPreview<Value: View>: View {

    private let dynamicTypeSizes: [ContentSizeCategory] = [.extraSmall, .large, .extraExtraExtraLarge]

    /// Filter out "base" to prevent a duplicate preview.
    private let localizations = Bundle.main.localizations.map(Locale.init).filter { $0.identifier != "base" }

    private let viewToPreview: Value

    init(_ viewToPreview: Value) {
        self.viewToPreview = viewToPreview
    }

    var body: some View {
        ScrollView {
            Group {
                preview1()
                darkMode()
                
                ForEach(localizations, id: \.identifier) { locale in
                    self.viewToPreview
                        .previewLayout(PreviewLayout.sizeThatFits)
                        .padding()
                        .environment(\.locale, locale)
                        .previewDisplayName(Locale.current.localizedString(forIdentifier: locale.identifier))
                }
                
                ForEach(dynamicTypeSizes, id: \.self) { sizeCategory in
                    self.viewToPreview
                        .previewLayout(PreviewLayout.sizeThatFits)
                        .padding()
                        .environment(\.sizeCategory, sizeCategory)
                        .previewDisplayName("\(sizeCategory)")
                }
                
            }
            
        }
    }
    
    @ViewBuilder
    func preview1() -> some View {
        self.viewToPreview
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
            .previewDisplayName("Default preview 1")
    }
    
    var systemBackground: UIColor {
        if #available(iOS 16.0, *) {
            return .gray
//            return UIColor.systemBackground Type 'UIColor' has no member 'systemBackground'
        } else {
            return .gray
        }
    }
    
    @ViewBuilder
    func darkMode() -> some View {
        self.viewToPreview
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
            .background(Color(systemBackground))
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Dark Mode")
    }
}
