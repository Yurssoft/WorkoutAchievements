//
//  RequestPermissionsView.swift
//
//  Created by Yurii B on 8/1/23.
//

import SwiftUI
import WorkoutsViewFeature
import WorkoutsClient

extension RequestPermissionsView {
    enum ViewState {
        case initial
        case showList
        case error
    }
}

public struct RequestPermissionsView: View {
    public init(workoutsClient: WorkoutsClient,
                selectedQuery: Binding<WorkoutTypeQuery>) {
        self.workoutsClient = workoutsClient
        self._selectedQuery = selectedQuery
    }
    
    @Binding private var selectedQuery: WorkoutTypeQuery
    
    let workoutsClient: WorkoutsClient
    @State private var state = ViewState.initial
    public var body: some View {
        VStack {
            switch state {
            case .initial:
                EmptyView()
                
            case .showList:
                WorkoutsView(client: workoutsClient, selectedQuery: $selectedQuery)
                
            case .error:
                Text("Error")
                
            }
            Spacer()
        }
        .onAppear() {
            checkAuthorizationStatusAndLoadList()
        }
    }
}

private extension RequestPermissionsView {
    func checkAuthorizationStatusAndLoadList() {
        Task {
            let statuses = workoutsClient.authorizationStatuses()
            switch (statuses.route, statuses.workout, statuses.summary) {
            case (.sharingDenied, .sharingDenied, .sharingDenied):
                state = .error
                
            case (.notDetermined, .notDetermined, .notDetermined):
                do {
                    try await workoutsClient.requestReadAuthorization()
                    state = .showList
                } catch {
                    state = .error
                }
                
            case (.sharingAuthorized, .sharingAuthorized, .sharingAuthorized):
                state = .showList
                
            default:
                state = .error
            }
        }
    }
}

#Preview {
    RequestPermissionsView(workoutsClient: .workoutsMock, selectedQuery: .constant(.init()))
}
