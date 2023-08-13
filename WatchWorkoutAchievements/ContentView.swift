//
//  ContentView.swift
//  WatchWorkoutAchievements
//
//  Created by Yurii B on 8/7/23.
//

import SwiftUI
import RequestPermissionsViewFeature
import WorkoutsClient

struct ContentView: View {
    let workoutsClient: WorkoutsClient
    
    var body: some View {
        RequestPermissionsView(workoutsClient: workoutsClient, selectedQuery: .constant(.init()))
    }
}

#Preview {
    ContentView(workoutsClient: .authorizedToReadMock)
}
