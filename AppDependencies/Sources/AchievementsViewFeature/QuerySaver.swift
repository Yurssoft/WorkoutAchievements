//
//  QuerySaver.swift
//
//  Created by Yurii B on 8/15/23.
//

import Foundation
import WorkoutsClient

final class QuerySaver {
    private static let key = String(describing: QuerySaver.self)
    private static let suiteName = "group.com.yurssoft.achievements.app.\(key)"
    
    private static func sharedDefaults() -> UserDefaults {
        let suite = UserDefaults(suiteName: suiteName)
        let standard = UserDefaults.standard
        return suite ?? standard
    }
    
    static func save(query: WorkoutTypeQuery) {
        let data = try? JSONEncoder().encode(query)
        sharedDefaults().setValue(data, forKey: key)
    }
    
    static func loadLastQuery() -> WorkoutTypeQuery {
        let data = sharedDefaults().value(forKey: key) as? Data ?? Data()
        let query = try? JSONDecoder().decode(WorkoutTypeQuery.self, from: data)
        return query ?? WorkoutTypeQuery()
    }
}
