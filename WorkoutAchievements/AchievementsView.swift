//
//  AchievementsView.swift
//  WorkoutAchievements
//
//  Created by Yurii B on 8/1/23.
//

import SwiftUI
import RequestPermissionsViewFeature
import WorkoutsClient

struct AchievementsView: View {
    let workoutsClient: WorkoutsClient
    
    var body: some View {
        VStack {
            RequestPermissionsView(workoutsClient: workoutsClient)
        }
        .padding()
    }
}

#Preview {
    AchievementsView(workoutsClient: .authorizedToReadMock)
}
