//
//  DictionaryError.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol StatusCodeContainable {
    var statusCode: Int? { get set }
}

public struct DictionaryError<T: BackendError>: JSONDecodable, Error, StatusCodeContainable {
    public typealias SupportedErrors = [T:[String]]
    public typealias UnsupportedErrors = [String:[String]]
    
    public let errors: SupportedErrors
    public let unsupported: UnsupportedErrors
    
    public var statusCode: Int?
    
    public init(json: JSON) {
        let dictionary = json.dictionaryObject as? [String:[String]] ?? [:]
        let converted = DictionaryError.convert(dictionary: dictionary)
        self.errors = converted.supported
        self.unsupported = converted.unsupported
    }
    
    public init(key: String, value: String, statusCode: Int? = 0) {
        let converted = DictionaryError.convert(dictionary: [key:[value]])
        self.errors = converted.supported
        self.unsupported = converted.unsupported
        self.statusCode = statusCode
    }
    
    public init(_ errors: [String:[String]]) {
        let converted = DictionaryError.convert(dictionary: errors)
        self.errors = converted.supported
        self.unsupported = converted.unsupported
    }
    
    public init(_ errors: [String:String]) {
        var dictionary : [String: [String]] = [:]
        errors.forEach{ dictionary[$0] = [$1] }
        let converted = DictionaryError.convert(dictionary: dictionary)
        self.errors = converted.supported
        self.unsupported = converted.unsupported
    }
    
    public init(_ supported: [T: [String]] = [:], unsupported: [String:[String]] = [:]) {
        self.errors = supported
        self.unsupported = unsupported
    }
    
    private static func convert(dictionary: UnsupportedErrors) -> (supported: SupportedErrors, unsupported: UnsupportedErrors) {
        var supportedErrors: SupportedErrors = [:]
        var unsupportedErrors: UnsupportedErrors = [:]
        
        dictionary.forEach { (key, messages) in
            do {
                let backendError = try T(backendKey: key)
                supportedErrors[backendError] = messages
            } catch {
                unsupportedErrors[key] = messages
            }
        }
        return (supportedErrors, unsupportedErrors)
    }
}

public protocol BackendError: Hashable {
    init(backendKey: String) throws
}

public enum BackendErrorBuildingError: Error {
    case unsupportedKey
}

extension DictionaryError {
    var first: String? {
        return errors.values.first?.first ?? unsupported.values.first?.first
    }
    
    var firstKey: T? {
        return errors.first?.key
    }
}

extension BackendError where Self: RawRepresentable, Self.RawValue == String {
    public init(backendKey: String) throws {
        self = try Self(rawValue: backendKey) ?? BackendErrorBuildingError.unsupportedKey.rethrow()
    }
}

extension String: BackendError {
    public init(backendKey: String) throws {
        self = backendKey
    }
}

extension BackendError where Self: RawRepresentable, Self.RawValue == Hashable {
    var hashValue: Int { return self.rawValue.hashValue }
}

infix operator <|: AdditionPrecedence
//swiftlint:disable:next large_tuple
func <| <T>(l: [T:[String]], r: (Bool, T, String)) -> [T:[String]] {
    guard r.0 else { return l }
    var errors = l[r.1] ?? []
    errors.append(r.2)
    var result = l
    result[r.1] = errors
    return result
}
