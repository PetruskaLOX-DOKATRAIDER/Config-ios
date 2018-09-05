//
//  Router.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class Route<T: UIViewController> : AppRouter.Presenter.Configuration<T> where T: ViewModelHolderProtocol{
    public var viewModelProvider: () throws -> T.ViewModelProtocol? = { nil }
    public let viewFactory: ViewFactory
    public let viewModelFactory: ViewModelFactory
    
    public init(
        router: AppRouterType,
        viewFactory: ViewFactory,
        viewModelFactory: ViewModelFactory
    ) {
        self.viewFactory = viewFactory
        self.viewModelFactory = viewModelFactory
        super.init(router: router)
    }
    
    public override func performConfiguration(for source: T) throws {
        try self.performViewModelInsertion(for: source)
        try super.performConfiguration(for: source)
    }
    
    public func buildViewModel() -> Self {
        viewModelProvider = { [viewModelFactory] in try viewModelFactory.buildViewModel() }
        return self
    }
    
    public func buildViewModel<ARG>(_ arg: ARG) -> Self {
        viewModelProvider = { [viewModelFactory] in try viewModelFactory.buildViewModel(arg: arg) }
        return self
    }
    
    public func buildViewModel<ARG, ARG2>(_ arg: ARG, _ arg2: ARG2) -> Self {
        viewModelProvider = { [viewModelFactory] in try viewModelFactory.buildViewModel(arg: arg, arg2: arg2) }
        return self
    }
    
    public func with(viewModel: T.ViewModelProtocol) -> Self {
        viewModelProvider = { viewModel }
        return self
    }
    
    public func performViewModelInsertion(for source: T) throws {
        source.viewModel = try viewModelProvider()
    }
    
    public func fromFactory() -> Self {
        return from{ [viewFactory] in try viewFactory.buildView() as T }
    }
}

extension Route {
    public func embed() -> Self {
        return embedIn { [viewFactory] in
            let nav = try viewFactory.buildView() as UINavigationController
            nav.setViewControllers([$0], animated: false)
            return nav
        }
    }
    
    public func dontEmbed() -> Self {
        return embedIn { $0 }
    }
    
    static func empty() -> AppRouter.Presenter.Configuration<T> {
        return T.presenter().from{ throw AppRouter.Presenter.Errors.failedToConstructSourceController }
    }
}

extension SharedSequenceConvertibleType where Self.E: RouteProtocol, Self.SharingStrategy == DriverSharingStrategy {
    public func push() -> Disposable {
        return self.drive(onNext: {
            $0.push()
        })
    }
    
    public func present() -> Disposable {
        return drive(onNext: {
            $0.present()
        })
    }
    
    public func setAsRoot() -> Disposable {
        return drive(onNext: {
            $0.setAsRoot()
        })
    }
}

extension ObservableType where Self.E: RouteProtocol {
    public func push() -> Disposable {
        return bind(onNext: {
            $0.push()
        })
    }
    
    public func present() -> Disposable {
        return bind(onNext: {
            $0.present()
        })
    }
    
    public func setAsRoot() -> Disposable {
        return bind(onNext: {
            $0.setAsRoot()
        })
    }
}

public protocol RouteProtocol {
    associatedtype RouteTarget
    
    @discardableResult
    func push() -> RouteTarget?
    
    @discardableResult
    func present() -> RouteTarget?
    
    @discardableResult
    func setAsRoot() -> RouteTarget?
}

extension AppRouter.Presenter.Configuration: RouteProtocol {}
