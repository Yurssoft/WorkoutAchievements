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

public struct AchievementsView: View {
    public init(workoutsClient: WorkoutsClient) {
        self.workoutsClient = workoutsClient
    }
    
    let workoutsClient: WorkoutsClient
    @State private var selectedQuery = WorkoutTypeQuery()
    
    public var body: some View {
        VStack {
            WorkoutTypeView(selectedQuery: $selectedQuery)
            RequestPermissionsView(workoutsClient: workoutsClient, selectedQuery: $selectedQuery)
        }
    }
}

#Preview {
    AchievementsView(workoutsClient: .authorizedToReadMock)
}
