//
//  DDLogMessage+Utils.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/2/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import APExtensions
import CocoaLumberjack
import Foundation
import RoutableLogger

public extension DDLogMessage {
    var parameters: Parameters? {
        return representedObject as? Parameters
    }
    
    var data: [String: Any?]? {
        return parameters?.data
    }
    
    var error: Any? {
        return parameters?.error
    }
    
    var logComponents: [LogComponent]? {
        return parameters?.logComponents
    }
    
    var flagLogString: String {
        return "\(flag) Log"
    }
}

// ******************************* MARK: - Parameters

public extension DDLogMessage {
    struct Parameters {
        public var data: [String: Any?]?
        public var error: Any?
        public var logComponents: [LogComponent]?
        public var normalizedData: [String: String]?
        public var normalizedError: String?
    }
}

public extension DDLogMessage.Parameters {
    
    init(data: [String: Any?]?, error: Any?, logComponents: [LogComponent]?) {
        self.data = data
        self.error = error
        self.logComponents = logComponents
        
        normalizedError = Utils.normalizeError(error)
        normalizedData = Utils.normalizeData(data)
        
        // Add localized description to data if it differs from the error
        let _localizedDescription = Utils.localizedDescription(error)
        if let localizedDescription = _localizedDescription,
           localizedDescription.hasElements,
           localizedDescription != normalizedError {
            
            normalizedData = normalizedData ?? [:]
            normalizedData?["localizedDescription"] = localizedDescription
        }
        
        // Add debug description to data if it differs from the error
        if let debugDescription = Utils.debugDescription(error),
           debugDescription.hasElements,
           debugDescription != normalizedError,
           debugDescription != _localizedDescription {
            
            normalizedData = normalizedData ?? [:]
            normalizedData?["debugDescription"] = debugDescription
        }
        
    userInfoIf:
        if let error = error as? Error, let userInfo = error._userInfo {
            if let occupiable = userInfo as? Occupiable, occupiable.isEmpty {
                break userInfoIf
            }
            
            let options: JSONSerialization.WritingOptions
            if #available(iOS 13.0, tvOS 13.0, macOS 10.15, watchOSApplicationExtension 6.0, watchOS 6.0, *) {
                options = [.sortedKeys, .fragmentsAllowed, .withoutEscapingSlashes]
            } else if #available(iOS 11.0, tvOS 11.0, macOS 10.13, watchOSApplicationExtension 4.0, watchOS 4.0, *) {
                options = [.sortedKeys, .fragmentsAllowed]
            } else {
                options = [.fragmentsAllowed]
            }
            
            normalizedData = normalizedData ?? [:]
            
            if JSONSerialization.isValidJSONObject(userInfo),
               let jsonData = try? JSONSerialization.data(withJSONObject: userInfo, options: options) {
                
                normalizedData?["errorUserInfoJSON"] = jsonData.asString
                
            } else {
                normalizedData?["errorUserInfo"] = "\(userInfo)"
            }
        }
    }
    
    /// Returns normalized data with compressed values if they exceed `allowedCount` limit.
    @available(iOS 13.0, *)
    func compressedNormalizedData(allowedCount: Int) -> [String: String]? {
        
        // Compressing data as much as possible using LZMA. It has ~10x compression rate for JSONs.
        normalizedData?
            .mapValues { value in
                // No need to compress values if they fit in the allowed count
                if value.count > allowedCount {
                    return value.data(using: .utf8)?
                        .safeCompressed(using: .lzma)?
                        .base64EncodedString()
                    ?? value
                } else {
                    return value
                }
            }
    }
}


// ******************************* MARK: - Compression

@available(iOS 13.0, watchOS 6.0, tvOS 13.0, macOS 10.15, *)
private extension Data {
    
    /// - note: In rare cases for some reason compression may fail
    func safeCompressed(using algorithm: NSData.CompressionAlgorithm) -> Data? {
        do {
            return try (self as NSData).compressed(using: algorithm) as Data
        } catch {
            RoutableLogger.logError("Unable to compress data", data: ["data": asString])
            return nil
        }
    }
    
    func safeDecompressed(using algorithm: NSData.CompressionAlgorithm) -> Data? {
        do {
            return try (self as NSData).decompressed(using: algorithm) as Data
        } catch {
            RoutableLogger.logError("Unable to decompress data", data: ["data": asString])
            return nil
        }
    }
}
