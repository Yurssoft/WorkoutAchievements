//
//  ErrorProcessor.swift
//  
//
//  Created by Yurii B on 11/25/23.
//

import Foundation
import HealthKit
import WorkoutsClient

enum ViewError {
    case emptyData
    case noDataAccess
    case generalError(code: String)
}

enum ErrorProcessor {
    
    private static func processHKError(error: Error) -> ViewError? {
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
        return .none
    }
    
    private static func processNSError(error: Error) -> ViewError? {
        let nsError = error as NSError
        if nsError.domain == HKErrorDomain {
            print("\(Self.self): NSError: error: \(nsError)")
            switch nsError.code {
            case 11:
                return .emptyData
                
            default:
                break
            }
        }
        return .none
    }
    
    private static func processGeneralError(_ error: Error) -> ViewError {
        if let hk = Self.processHKError(error: error) {
            return hk
        }
        if let ns = Self.processNSError(error: error) {
            return ns
        }
        print("\(Self.self): error: \(error)")
        return generalError
    }
    
    static func processError(_ error: Error) -> ViewError {
        if let error = processHKError(error: error) {
            return error
        }
        if let worckoutClientError = error as? WorkoutsClientError {
            switch worckoutClientError {
            case .fetchingWorkouts(underlying: let underlying):
                switch underlying {
                case .workoutsNil:
                    return .emptyData
                case .underlying(let underError):
                    return Self.processGeneralError(underError)
                }
            case .fetchingStatistics(underlying: let underlying):
                switch underlying {
                case .statisticsNil:
                    return .emptyData
                case .underlying(let underError):
                    return Self.processGeneralError(underError)
                }
            case .cannotCreateQuantityType:
                return generalError
            case .healthKitIsNotAvailable:
                return generalError
            }
        }
        if let error = processNSError(error: error) {
            return error
        }
        return generalError
    }
    
    private static let generalError = ViewError.generalError(code: "-1 unrecognized")
}
