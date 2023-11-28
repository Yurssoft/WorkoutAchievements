//
//  ErrorProcessor.swift
//  
//
//  Created by Yurii B on 11/25/23.
//

import Foundation
import HealthKit

enum ViewError {
    case emptyData
    case noDataAccess
    case generalError(code: String)
}

enum ErrorProcessor {
    static func processError(_ error: Error) -> ViewError {
        if let healthKitError = error as? HKError {
            let code = healthKitError.code
            print("\(Self.self): error code: \(code), error: \(healthKitError)")
            switch code {
            case .errorHealthDataRestricted:
                return .noDataAccess
            case .errorAuthorizationDenied:
                return .noDataAccess
            case .errorAuthorizationNotDetermined:
                return .noDataAccess
            case .errorDatabaseInaccessible:
                return .noDataAccess
            case .errorUserCanceled:
                return .noDataAccess
            case .errorRequiredAuthorizationDenied:
                return .noDataAccess
            case .errorNoData:
                return .emptyData
            default:
                return .generalError(code: "\(code.rawValue)")
            }
        }
        return .generalError(code: "-1 unrecognized")
    }
}
