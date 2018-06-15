open class Route<T: UIViewController> : AppRouter.Presenter.Configuration<T> where T: ViewModelHolderProtocol{
    open var viewModelProvider: () throws -> T.ViewModelProtocol? = { nil }
    
    public let viewFactory: ViewFactoryType
    public let viewModelFactory: ViewModelFactoryType
    
    public init(router: AppRouterType, viewFactory: ViewFactoryType, viewModelFactory: ViewModelFactoryType) {
        self.viewFactory = viewFactory
        self.viewModelFactory = viewModelFactory
        super.init(router: router)
    }
    
    open override func performConfiguration(for source: T) throws {
        try self.performViewModelInsertion(for: source)
        try super.performConfiguration(for: source)
    }
    
    open func buildViewModel() -> Self {
        viewModelProvider = { [viewModelFactory] in try viewModelFactory.buildViewModel() }
        return self
    }
    
    open func buildViewModel<ARG>(_ arg: ARG) -> Self {
        viewModelProvider = { [viewModelFactory] in try viewModelFactory.buildViewModel(arg: arg) }
        return self
    }
    
    open func buildViewModel<ARG, ARG2>(_ arg: ARG, _ arg2: ARG2) -> Self {
        viewModelProvider = { [viewModelFactory] in try viewModelFactory.buildViewModel(arg: arg, arg2: arg2) }
        return self
    }
    
    open func with(viewModel: T.ViewModelProtocol) -> Self {
        viewModelProvider = { viewModel }
        return self
    }
    
    open func performViewModelInsertion(for source: T) throws {
        source.viewModel = try viewModelProvider()
    }
    
    open func fromFactory() -> Self {
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
