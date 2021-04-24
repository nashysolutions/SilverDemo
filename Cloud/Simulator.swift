//
//  Simulator.swift
//  Cloud
//
//  Created by Robert Nash on 16/09/2020.
//  Copyright © 2020 Robert Nash. All rights reserved.
//

import Silver
import CloudKit

class ContainerSimulator: CloudContainer {
    
    var publicCloudDatabase: CKDatabase {
        fatalError()
    }
    
    /// The frequency that a simulated error will occur (0-1)
    private var simulateErrorRate: Float = 1
    
    /// How long to wait before returning a simulated error
    private let simulateErrorDelay: TimeInterval = 1
    
    /// The types of errors that can be simulated
    private let simulateErrorsPossibleCodes: [CKError.Code] = [
        .networkFailure,
        .serviceUnavailable,
        .networkUnavailable,
        .incompatibleVersion,
        .requestRateLimited,
        .operationCancelled,
        .serverResponseLost,
        .zoneNotFound
    ]
    
    func enableSimulatedErrors(errorRate: Float) {
        simulateErrorRate = max(0, min(1, errorRate))
    }
    
    private func delay(_ delay: TimeInterval, _ closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
    }
    
    func accountStatus(completionHandler: @escaping (CKAccountStatus, Error?) -> Void) {
        if shouldThrowError() {
            delay(simulateErrorDelay) {
                completionHandler(.couldNotDetermine, self.createRandomError())
            }
        }
        else {
            completionHandler(.available, nil)
        }
    }
    
    func status(forApplicationPermission applicationPermission: CKContainer_Application_Permissions, completionHandler: @escaping CKContainer_Application_PermissionBlock) {
        if shouldThrowError() {
            delay(simulateErrorDelay) {
                completionHandler(.couldNotComplete, self.createRandomError())
            }
        }
        else {
            completionHandler(.granted, nil)
        }
    }
        
    func requestApplicationPermission(_ applicationPermission: CKContainer_Application_Permissions, completionHandler: @escaping CKContainer_Application_PermissionBlock) {
        if shouldThrowError() {
            delay(simulateErrorDelay) {
                completionHandler(.couldNotComplete, self.createRandomError())
            }
        }
        else {
            completionHandler(.granted, createRandomError())
        }
    }
    
    private func shouldThrowError() -> Bool {
        guard simulateErrorRate > 0 else {
            return false
        }
        
        let rand = Float(arc4random()) / Float(UInt32.max)
        return rand < simulateErrorRate
    }
    
    fileprivate func createRandomError(_ additionalCodes: [CKError.Code] = []) -> CKError {
        let errors: [CKError.Code] = simulateErrorsPossibleCodes + additionalCodes
        let code = errors.randomElement()!
        return createError(code: code)
    }
    
    fileprivate func createError(code: CKError.Code) -> CKError {
        let error = NSError(
            domain: CKErrorDomain,
            code: code.rawValue,
            userInfo: [CKErrorRetryAfterKey: NSNumber(value: 3)]
        )
        return CKError(_nsError: error)
    }
}
