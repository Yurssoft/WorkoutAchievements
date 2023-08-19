//
//  ContentView.swift
//  WatchWorkoutAchievements
//
//  Created by Yurii B on 8/7/23.
//

import SwiftUI
import WorkoutsClient
import AchievementsViewFeature

struct ContentView: View {
    let workoutsClient: WorkoutsClient
    
    var body: some View {
        ScrollView {
            AchievementsView(workoutsClient: workoutsClient)
        }
    }
}

#Preview {
    ContentView(workoutsClient: .workoutsMock)
}
