//
//  HealthListView.swift
//  WorkoutAchievements
//
//  Created by Yurii B on 8/1/23.
//

import SwiftUI
import WorkoutsViewFeature
import WorkoutsClient
import WorkoutsClientLive

struct AchievementsView: View {
    let workoutsClient: WorkoutsClient
    var body: some View {
        VStack {
            WorkoutsView(client: workoutsClient)
        }
        .padding()
    }
}

#Preview {
    AchievementsView(workoutsClient: .authorizedToReadMock)
}
