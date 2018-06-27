import RxCocoa
import AppRouter
import SafariServices

open class Router: ReactiveCompatible {
    public let viewFactory: ViewFactory
    public let viewModelFactory: ViewModelFactory
    public let router: AppRouterType
    
    public init(router: AppRouterType, viewFactory: ViewFactory, viewModelFactory: ViewModelFactory) {
        self.router = router
        self.viewFactory = viewFactory
        self.viewModelFactory = viewModelFactory
    }

    public func splash() -> AppRouter.Presenter.Configuration<UIViewController> {
        return UIViewController.presenter().from {
            try UIStoryboard("LaunchScreen", bundle: .core).instantiateInitialViewController() ?? AppRouter.Presenter.Errors.failedToConstructSourceController.rethrow()
        }
    }

    public func tutorial() -> Route<TutorialViewController> {
        return route().configure({ [ appSections = appSections() ] in
            $0.viewModel?.shouldRouteSettings.map(to: true).drive($0.rx.close).disposed(by: $0.rx.disposeBag)
            $0.viewModel?.shouldRouteApp.map(to: appSections).setAsRoot().disposed(by: $0.rx.disposeBag)
        }).embedInNavigation(NavigationControllerFactory.new())
    }
    
    public func appSections() -> AppRouter.Presenter.Configuration<AppSectionsTabBarController> {
        return AppSectionsTabBarController.presenter().from { [viewFactory = viewFactory] in
            let tabbarVC: AppSectionsTabBarController = try viewFactory.buildView()
            tabbarVC.setViewControllers([
                try self.players().embedInNavigation(NavigationControllerFactory.new()).provideSourceController(),
                try self.teams().embedInNavigation(NavigationControllerFactory.new()).provideSourceController(),
                try self.events().embedInNavigation(NavigationControllerFactory.new()).provideSourceController(),
                try self.news().embedInNavigation(NavigationControllerFactory.new()).provideSourceController(),
                try self.profile().embedInNavigation(NavigationControllerFactory.new()).provideSourceController()
            ], animated: true)
            return tabbarVC
        }
    }
    
    public func news() -> Route<NewsViewController> {
        return route()
    }
    
    public func profile() -> Route<ProfileViewController> {
        return route()
    }
    
    public func events() -> Route<EventsViewController> {
        return route()
    }
    
    public func teams() -> Route<TeamsViewController> {
        return route()
    }
    
    public func players() -> Route<PlayersViewController> {
        return route()
    }
    
    private func route<T: UIViewController>() -> Route<T> where T: ViewModelHolderProtocol {
        return Route<T>(router: router, viewFactory: viewFactory, viewModelFactory: viewModelFactory).fromFactory().buildViewModel()
    }
    
}
