//
//  QuerySaver.swift
//
//  Created by Yurii B on 8/15/23.
//

import Foundation
import WorkoutsClient

final class QuerySaver {
    private static let key = String(describing: QuerySaver.self)
    static func save(query: WorkoutTypeQuery) {
        let data = try? JSONEncoder().encode(query)
        UserDefaults.standard.setValue(data, forKey: key)
    }
    
    static func loadLastQuery() -> WorkoutTypeQuery {
        let data = UserDefaults.standard.value(forKey: key) as? Data ?? Data()
        let query = try? JSONDecoder().decode(WorkoutTypeQuery.self, from: data)
        return query ?? WorkoutTypeQuery()
    }
}
