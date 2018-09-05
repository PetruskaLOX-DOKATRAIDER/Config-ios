//
//  ViewFactoryType.swift
//  Core
//
//  Created by Oleg Petrychuk on 25.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol ViewFactory {
    func buildView<T>() throws -> T where T: UIViewController
    func buildView<T, ARG>(arg: ARG) throws -> T where T: UIViewController
}

extension DependencyContainer: ViewFactory {
    public func buildView<T>() throws -> T where T: UIViewController {
        return try resolver{ try self.resolve() }
    }
    
    public func buildView<T, ARG1>(arg: ARG1) throws -> T where T: UIViewController {
        return try resolver{ try self.resolve(arguments: arg) }
    }
    
    public enum ViewFactoryError: Error {
        case failedToBuild
    }
    
    func resolver<T: UIViewController>(factory: () throws -> T) throws -> T {
        // supressing redundant console spam
        let logLevel = Dip.logLevel
        Dip.logLevel = .None
        defer { Dip.logLevel = logLevel }
        
        do {
            return try factory()
        } catch let error as ViewFactoryError {
            throw error
        } catch {
            register { // if faild to resolve controller - registering universal factory
                try T.instantiate(initial: true) ?? ViewFactoryError.failedToBuild.rethrow()
            }
            return try buildView()
        }
    }
}
