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

extension AchievementsView {
    enum ViewState {
        case initialized
        case showList
        case error
    }
}

struct AchievementsView: View {
    let workoutsClient: WorkoutsClient
    @State private var state = ViewState.initialized
    var body: some View {
        VStack {
            switch state {
            case .initialized:
                Button("Request Authorization & Load List") {
                    checkAuthorizationStatusAndLoadList()
                }
                
            case .showList:
                WorkoutsView(client: workoutsClient)
                
            case .error:
                Text("Error")
            }
        }
        .padding()
    }
}

private extension AchievementsView {
    func checkAuthorizationStatusAndLoadList() {
        Task {
            do {
                try await workoutsClient.requestReadAuthorization()
                state = .showList
            } catch {
                state = .error
            }
        }
    }
}

#Preview {
    AchievementsView(workoutsClient: .authorizedToReadMock)
}
