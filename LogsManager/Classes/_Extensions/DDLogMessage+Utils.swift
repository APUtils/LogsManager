//
//  DDLogMessage+Utils.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/2/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

#if SPM
import APExtensionsOccupiable
#else
import APExtensions
#endif
import CocoaLumberjack
import Foundation
import RoutableLogger

public extension DDLogMessage {
    var parameters: Parameters? {
        return representedObject as? Parameters
    }
    
    var data: [AnyHashable: Any?]? {
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
        public var data: [AnyHashable: Any?]?
        public var error: Any?
        public var logComponents: [LogComponent]?
        public var normalizedData: [String: String]?
        public var normalizedError: String?
    }
}

public extension DDLogMessage.Parameters {
    
    init(data: [AnyHashable: Any?]?, error: Any?, logComponents: [LogComponent]?) {
        self.data = data
        self.error = error
        self.logComponents = logComponents
        
        normalizedError = Utils.normalizeError(error)
        normalizedData = Utils.normalizeData(data, skipDataNormalizationKeyPrefix: Constants.skipDataNormalizationKeyPrefix)
        
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
           normalizedError?.hasSuffix(debugDescription) != true,
           debugDescription != _localizedDescription {
            
            normalizedData = normalizedData ?? [:]
            normalizedData?["debugDescription"] = debugDescription
        }
        
        if let localizedFailureReason = Utils.localizedFailureReason(error) {
            normalizedData = normalizedData ?? [:]
            normalizedData?["localizedFailureReason"] = localizedFailureReason
        }
        
        if let localizedRecoverySuggestion = Utils.localizedRecoverySuggestion(error) {
            normalizedData = normalizedData ?? [:]
            normalizedData?["localizedRecoverySuggestion"] = localizedRecoverySuggestion
        }
        
        if let localizedRecoveryOptions = Utils.localizedRecoveryOptions(error) {
            normalizedData = normalizedData ?? [:]
            normalizedData?["localizedRecoveryOptions"] = localizedRecoveryOptions
        }
        
        if let helpAnchor = Utils.helpAnchor(error) {
            normalizedData = normalizedData ?? [:]
            normalizedData?["helpAnchor"] = helpAnchor
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
    @available(iOS 13.0, watchOSApplicationExtension 6.0, watchOS 6.0, tvOS 13.0, macOS 10.15, *)
    func compressedNormalizedData(allowedCount: Int) -> [String: String]? {
        normalizedData?.mapValues { Self.compressIfNeeded(string: $0, allowedCount: allowedCount) }
    }
    
    /// Returns normalized data with compressed values if they exceed `allowedCount` limit.
    @available(iOS 13.0, watchOSApplicationExtension 6.0, watchOS 6.0, tvOS 13.0, macOS 10.15, *)
    static func compressIfNeeded(string: String, allowedCount: Int) -> String {
        // No need to compress values if they fit in the allowed count
        if string.count > allowedCount {
            let compressedString = string.data(using: .utf8)?
            // Compressing data as much as possible using LZMA. It has ~10x compression rate for JSONs.
                .safeCompressed(using: .lzma)?
                .base64EncodedString()
            ?? string
            
            // Check if compression actually makes sense
            if compressedString.count < string.count {
                return compressedString
            } else {
                return string
            }
            
        } else {
            return string
        }
    }
}

// ******************************* MARK: - Constants

public extension DDLogMessage.Parameters { enum Constants {} }
public extension DDLogMessage.Parameters.Constants {
    static let skipDataNormalizationKeyPrefix = "_skip_normalization_"
}

// ******************************* MARK: - Compression

@available(iOS 13.0, watchOSApplicationExtension 6.0, watchOS 6.0, tvOS 13.0, macOS 10.15, *)
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
