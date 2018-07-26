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
        return AppSectionsTabBarController.presenter().from {
            let tabbarVC = AppSectionsTabBarController()
            tabbarVC.setViewControllers([
                NavigationControllerFactory.new(viewControllers: [try self.players().provideSourceController()]),
                NavigationControllerFactory.new(viewControllers: [try self.teams().provideSourceController()]),
                NavigationControllerFactory.new(viewControllers: [try self.events().provideSourceController()]),
                NavigationControllerFactory.new(viewControllers: [try self.news().provideSourceController()]),
                NavigationControllerFactory.new(viewControllers: [try self.profile().provideSourceController()])
            ], animated: false)
            return tabbarVC
        }
    }
    
    public func news() -> Route<NewsViewController> {
        return route()
    }
    
    public func profile() -> Route<ProfileViewController> {
        return route()
    }
    
    public func events() -> Route<EventsContainerViewController> {
        return route().configure({ [ eventFilters = eventFilters() ] in
            $0.viewModel?.shouldRouteFilters.map(to: eventFilters).present().disposed(by: $0.rx.disposeBag)
        }).embedInNavigation(NavigationControllerFactory.new())
    }
    
    public func teams() -> Route<TeamsViewController> {
        return route().configure({ vc in
            vc.viewModel?.shouldRouteProfile.drive(onNext: {
                vc.tabBarController?.setSelectedViewController(ProfileViewController.self)
            }).disposed(by: vc.rx.disposeBag)
        })
    }
    
    public func players() -> Route<PlayersViewController> {
        return route().configure({ vc in
            vc.viewModel?.shouldRouteProfile.drive(onNext: {
                vc.tabBarController?.setSelectedViewController(ProfileViewController.self)
            }).disposed(by: vc.rx.disposeBag)
        })
    }
    
    public func eventFilters() -> Route<EventsFilterViewController> {
        return route().configure({ [ picekrVC = picekr(), datePicekrVC = datePicekr() ] vc in
            guard let navigationController = vc.navigationController else { return }
            vc.viewModel?.shouldClose.map(to: true).drive(navigationController.rx.close).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldRoutePicker.map{ picekrVC.with(viewModel: $0) }.present().disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldRouteDatePicker.map{ datePicekrVC.with(viewModel: $0) }.present().disposed(by: vc.rx.disposeBag)
        }).embedInNavigation(NavigationControllerFactory.new())
    }
    
    public func datePicekr() -> Route<DatePickerViewController> {
        return route().configure({ vc in
            vc.viewModel?.shouldClose.map(to: true).drive(vc.rx.close).disposed(by: vc.rx.disposeBag)
        })
    }
    
    public func picekr() -> Route<PickerViewController> {
        return route().configure({ vc in
            vc.viewModel?.shouldClose.map(to: true).drive(vc.rx.close).disposed(by: vc.rx.disposeBag)
        })
    }
    
    private func route<T: UIViewController>() -> Route<T> where T: ViewModelHolderProtocol {
        return Route<T>(router: router, viewFactory: viewFactory, viewModelFactory: viewModelFactory).fromFactory().buildViewModel()
    }
}
