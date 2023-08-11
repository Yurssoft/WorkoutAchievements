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

struct AchievementsView: View {
    let workoutsClient: WorkoutsClient
    @State private var selectedQuery = WorkoutTypeQuery()
    
    var body: some View {
        VStack {
            WorkoutTypeView(selectedQuery: $selectedQuery)
            RequestPermissionsView(workoutsClient: workoutsClient, selectedQuery: $selectedQuery)
        }
        .padding()
    }
}

#Preview {
    AchievementsView(workoutsClient: .authorizedToReadMock)
}
