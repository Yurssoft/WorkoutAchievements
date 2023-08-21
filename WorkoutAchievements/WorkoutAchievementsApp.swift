//
//  WorkoutAchievementsApp.swift
//  WorkoutAchievements
//
//  Created by Yurii B on 8/1/23.
//

import SwiftUI
import WorkoutsClient
import WorkoutsClientLive
import AchievementsViewFeature

@main
struct WorkoutAchievementsApp: App {
    private let workoutsClient = WorkoutsClient.live
    var body: some Scene {
        WindowGroup {
            AchievementsView(workoutsClient: workoutsClient)
        }
    }
}
