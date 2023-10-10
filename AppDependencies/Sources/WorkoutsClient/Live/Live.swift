//
//  Live.swift
//  WorkoutAchievements
//
//  Created by Yurii B on 8/3/23.
//

import Foundation
import WorkoutsClient
import HealthKit

extension WorkoutsClient {
    static var liveClient = {
        let store = HKHealthStore()
        let permissions = HealthKitPermissions(store: store)
        return Self { type in
            let result = try await WorkoutLoader.fetchData(for: type, store: store)
            return result
        } requestReadAuthorization: {
            try await permissions.requestReadPemissions()
        } authorizationStatuses: {
            permissions.authorizationStatuses()
        }
    }
    
    public static let live = liveClient()
}
