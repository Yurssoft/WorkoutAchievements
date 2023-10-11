//
//  WatchWorkoutAchievementsApp.swift
//  WatchWorkoutAchievements
//
//  Created by Yurii B on 8/7/23.
//

import SwiftUI
import WorkoutsClient
import WorkoutsClientLive

@main
struct WatchWorkoutAchievementsApp: App {
    private let workoutsClient = WorkoutsClient.live
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(workoutsClient: workoutsClient)
            }
        }
    }
}
