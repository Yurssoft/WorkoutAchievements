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
        case initialized
        case showList
        case error
    }
}

public struct RequestPermissionsView: View {
    public init(workoutsClient: WorkoutsClient) {
        self.workoutsClient = workoutsClient
    }
    
    let workoutsClient: WorkoutsClient
    @State private var state = ViewState.initialized
    public var body: some View {
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

private extension RequestPermissionsView {
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
    RequestPermissionsView(workoutsClient: .authorizedToReadMock)
}
