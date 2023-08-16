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
    }
    
    let workoutsClient: WorkoutsClient
    @State private var selectedQuery = QuerySaver.loadLastQuery()
    
    public var body: some View {
        VStack {
            WorkoutTypeView(selectedQuery: $selectedQuery)
            RequestPermissionsView(workoutsClient: workoutsClient, selectedQuery: $selectedQuery)
            Spacer()
        }
        .onChange(of: selectedQuery) { _, newValue in
            QuerySaver.save(query: newValue)
        }
    }
}

#Preview {
    AchievementsView(workoutsClient: .authorizedToReadMock)
}
