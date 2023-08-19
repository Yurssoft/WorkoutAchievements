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
    private let workoutsClient = WorkoutsClient.liveClient()
    
    var body: some Scene {
        WindowGroup {
            ContentView(workoutsClient: workoutsClient)
        }
    }
}
