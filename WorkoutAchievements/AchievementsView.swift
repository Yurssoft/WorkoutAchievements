//
//  HealthListView.swift
//  WorkoutAchievements
//
//  Created by Yurii B on 8/1/23.
//

import SwiftUI
import WorkoutsViewFeature
import WorkoutsClientLive

struct AchievementsView: View {
    var body: some View {
        VStack {
            WorkoutsView(client: .live)
        }
        .padding()
    }
}

#Preview {
    AchievementsView()
}
