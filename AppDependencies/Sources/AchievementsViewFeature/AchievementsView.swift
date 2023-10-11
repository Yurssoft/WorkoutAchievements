//
//  AchievementsView.swift
//  WorkoutAchievements
//
//  Created by Yurii B on 8/1/23.
//

import SwiftUI
import RequestPermissionsViewFeature
import WorkoutsClient
import WorkoutTypeViewFeature

public struct AchievementsView: View {
    public init(workoutsClient: WorkoutsClient) {
        self.workoutsClient = workoutsClient
        let lastSavedQuery = QuerySaver.loadLastQuery()
        let viewModelObj = WorkoutTypeView.ViewModel(selectedQuery: lastSavedQuery)
        viewModel = viewModelObj
    }
    
    private let workoutsClient: WorkoutsClient
    @Bindable private var viewModel: WorkoutTypeView.ViewModel
    
    public var body: some View {
        ScrollView {
            VStack {
                WorkoutTypeView(viewModel: viewModel)
                Divider().overlay(Color.gray)
                RequestPermissionsView(workoutsClient: workoutsClient, selectedQuery: $viewModel.selectedQuery)
                Spacer()
            }
        }
        .navigationTitle("Achievements")
    }
}

#Preview {
    UIElementPreview(
        AchievementsView(workoutsClient: .workoutsMock)
    )
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
                self.viewToPreview
                    .previewLayout(PreviewLayout.sizeThatFits)
                    .padding()
                    .previewDisplayName("Default preview 1")
                
                self.viewToPreview
                    .previewLayout(PreviewLayout.sizeThatFits)
                    .padding()
                    .background(Color(.systemBackground))
                    .environment(\.colorScheme, .dark)
                    .previewDisplayName("Dark Mode")
                
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
}
