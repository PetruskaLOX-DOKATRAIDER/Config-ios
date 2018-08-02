import RxCocoa
import AppRouter
import SafariServices

open class Router: ReactiveCompatible {
    public let viewFactory: ViewFactory
    public let viewModelFactory: ViewModelFactory
    public let router: AppRouterType
    public let deviceRouter: DeviceRouter
    
    public init(
        router: AppRouterType,
        viewFactory: ViewFactory,
        viewModelFactory: ViewModelFactory,
        deviceRouter: DeviceRouter
    ) {
        self.router = router
        self.viewFactory = viewFactory
        self.viewModelFactory = viewModelFactory
        self.deviceRouter = deviceRouter
    }

    public func splash() -> AppRouter.Presenter.Configuration<UIViewController> {
        return UIViewController.presenter().from {
            try UIStoryboard("LaunchScreen", bundle: .core).instantiateInitialViewController() ?? AppRouter.Presenter.Errors.failedToConstructSourceController.rethrow()
        }
    }

    public func tutorial() -> Route<TutorialViewController> {
        return route().configure({ [ appSections = appSections() ] vc in
            vc.viewModel?.shouldRouteSettings.map(to: true).drive(vc.rx.close).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldRouteApp.map(to: appSections).setAsRoot().disposed(by: vc.rx.disposeBag)
        }).embedInNavigation(NavigationControllerFactory.default())
    }
    
    public func appSections() -> AppRouter.Presenter.Configuration<AppSectionsTabBarController> {
        return AppSectionsTabBarController.presenter().from {
            let tabbarVC = AppSectionsTabBarController()
            tabbarVC.setViewControllers([
                NavigationControllerFactory.default(viewControllers: [try self.players().provideSourceController()])
//                NavigationControllerFactory.default(viewControllers: [try self.teams().provideSourceController()]),
//                NavigationControllerFactory.default(viewControllers: [try self.events().provideSourceController()]),
//                NavigationControllerFactory.default(viewControllers: [try self.news().provideSourceController()]),
//                NavigationControllerFactory.default(viewControllers: [try self.profile().provideSourceController()])
            ], animated: false)
            return tabbarVC
        }
    }
    
    public func news() -> Route<NewsViewController> {
        return route().configure({ [ newsDescription = newsDescription() ] vc in
            vc.viewModel?.shouldRouteProfile.drive(onNext: { [weak vc] in
                vc?.tabBarController?.setSelectedViewController(ProfileViewController.self)
            }).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldRouteNewsDescription.map(newsDescription.buildViewModel).present().disposed(by: vc.rx.disposeBag)
        })
    }
    
    public func profile() -> Route<ProfileViewController> {
        return route()
    }
    
    public func events() -> Route<EventsContainerViewController> {
        return route().configure({ [ eventFilters = eventFilters() ] vc in
            vc.viewModel?.shouldRouteFilters.map(to: eventFilters).present().disposed(by: vc.rx.disposeBag)
        }).embedInNavigation(NavigationControllerFactory.default())
    }
    
    public func teams() -> Route<TeamsViewController> {
        return route().configure({ [playerDescription = playerDescription()] vc in
            vc.viewModel?.shouldRouteProfile.drive(onNext: { [weak vc] in
                vc?.tabBarController?.setSelectedViewController(ProfileViewController.self)
            }).disposed(by: vc.rx.disposeBag)
            Driver.merge([
                vc.viewModel?.shouldRoutePlayerDescription,
                vc.viewModel?.playersBannerViewModel.shouldRoutePlayerDescription
            ].flatMap{ $0 }).map(playerDescription.buildViewModel).present().disposed(by: vc.rx.disposeBag)
        })
    }
    
    public func players() -> Route<PlayersViewController> {
        return route().configure({ [ playerDescription = playerDescription() ] vc in
            vc.viewModel?.shouldRouteProfile.drive(onNext: { [weak vc] in
                vc?.tabBarController?.setSelectedViewController(ProfileViewController.self)
            }).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldRoutePlayerDescription.map(playerDescription.buildViewModel).present().disposed(by: vc.rx.disposeBag)
        })
    }
    
    public func eventFilters() -> Route<EventsFilterViewController> {
        return route().configure({ [ picekrVC = picekr(), datePicekrVC = datePicekr() ] vc in
            guard let nvc = vc.navigationController else { return }
            nvc.addMotionTransition(.zoom)
            vc.viewModel?.shouldClose.map(to: MotionTransitionAnimationType.zoomOut).drive(nvc.rx.motiondClose).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldRoutePicker.map{ picekrVC.with(viewModel: $0) }.present().disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldRouteDatePicker.map{ datePicekrVC.with(viewModel: $0) }.present().disposed(by: vc.rx.disposeBag)
        }).embedInNavigation(NavigationControllerFactory.default())
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
    
    public func playerDescription() -> Route<PlayerDescriptionViewController> {
        return route().configure({ vc in
            guard let nvc = vc.navigationController else { return }
            nvc.addMotionTransition(.zoomSlide(direction: .left))
            vc.viewModel?.shouldClose.map(to: MotionTransitionAnimationType.zoomSlide(direction: .right)).drive(nvc.rx.motiondClose).disposed(by: vc.rx.disposeBag)
        }).embedInNavigation(NavigationControllerFactory.clear())
    }
    
    public func newsDescription() -> Route<NewsDescriptionViewController> {
        return route().configure({ [ imageViewer = imageViewer() ] vc in
            guard let nvc = vc.navigationController else { return }
            nvc.addMotionTransition(.zoomSlide(direction: .left))
            vc.viewModel?.shouldClose.map(to: MotionTransitionAnimationType.zoomSlide(direction: .right)).drive(nvc.rx.motiondClose).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldRouteImageViewer.map(imageViewer.buildViewModel).present().disposed(by: vc.rx.disposeBag)
        }).embedInNavigation(NavigationControllerFactory.clear())
    }
    
    public func imageViewer() -> Route<ImageViewerViewController> {
        return route().configure({ vc in
            guard let nvc = vc.navigationController else { return }
            nvc.addMotionTransition(.zoom)
            vc.viewModel?.shouldClose.map(to: MotionTransitionAnimationType.zoomOut).drive(nvc.rx.motiondClose).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldOpenURL.drive(onNext: { [weak nvc] url in
                nvc?.pushViewController(SFSafariViewController(url: url), animated: true)
            }).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shoudShowAlert.map{ UIAlertControllerFactory.alertController(fromViewModelAlert: $0) }.drive(onNext: { [weak nvc] alert in
                nvc?.present(alert, animated: true, completion: nil)
            }).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldRouteAppSettings.drive(onNext: { [weak self] in
                try? self?.deviceRouter.openSettings()
            }).disposed(by: vc.rx.disposeBag)
        }).embedInNavigation(NavigationControllerFactory.default())
    }
    
    private func route<T: UIViewController>() -> Route<T> where T: ViewModelHolderProtocol {
        return Route<T>(router: router, viewFactory: viewFactory, viewModelFactory: viewModelFactory).fromFactory().buildViewModel()
    }
}
