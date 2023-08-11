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
        VStack {
            RequestPermissionsView(workoutsClient: workoutsClient, selectedQuery: .constant(.init()))
        }
        .padding()
    }
}

#Preview {
    ContentView(workoutsClient: .authorizedToReadMock)
}
