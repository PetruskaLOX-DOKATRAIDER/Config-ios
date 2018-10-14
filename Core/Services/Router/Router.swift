//
//  Router.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class Router: ReactiveCompatible {
    private let alertAnimator = AlertTransitionAnimator()
    private let viewModelFactory: ViewModelFactory
    private let deviceRouter: DeviceRouter
    private let viewFactory: ViewFactory
    public let appRouter: AppRouterType
    
    public init(
        router: AppRouterType,
        viewFactory: ViewFactory,
        viewModelFactory: ViewModelFactory,
        deviceRouter: DeviceRouter
    ) {
        self.appRouter = router
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
        return route().configure({ [appSections = appSections()] vc in
            vc.viewModel?.shouldClose.map(to: true).drive(vc.rx.close).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldRouteApp.map(to: appSections).setAsRoot().disposed(by: vc.rx.disposeBag)
        }).embedInNavigation(NavigationControllerFactory.`default`())
    }
    
    public func appSections() -> AppRouter.Presenter.Configuration<AnimatedTabBarController> {
        return AnimatedTabBarController.presenter().from {
            let tabbarVC = AnimatedTabBarController()
            tabbarVC.setViewControllers([
                NavigationControllerFactory.`default`(viewControllers: [try self.players().provideSourceController()]),
                NavigationControllerFactory.`default`(viewControllers: [try self.teams().provideSourceController()]),
                NavigationControllerFactory.`default`(viewControllers: [try self.events().provideSourceController()]),
                NavigationControllerFactory.`default`(viewControllers: [try self.news().provideSourceController()]),
                NavigationControllerFactory.`default`(viewControllers: [try self.profile().provideSourceController()])],
            animated: false)
            return tabbarVC
        }
    }
    
    public func news() -> Route<NewsViewController> {
        return route().configure({ [weak self, newsDescription = newsDescription()] vc in
            guard let strongSelf = self else { return }
            vc.viewModel?.shouldRouteProfile.drive(onNext: { [weak vc] in vc?.tabBarController?.setSelectedViewController(ProfileViewController.self) }).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldRouteDescription.map(newsDescription.buildViewModel).present().disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldShare.drive(strongSelf.rx.presentActivityVC).disposed(by: vc.rx.disposeBag)
        })
    }
    
    public func profile() -> Route<ProfileViewController> {
        return route().configure({ [weak self, favoritePlayers = favoritePlayers(), skins = skins(), feedback = feedback(), tutorial = tutorial()] vc in
            guard let strongSelf = self else { return }
            vc.viewModel?.shouldRouteFavoritePlayers.map(to: favoritePlayers).push().disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldRouteSkins.map(to: skins).push().disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldOpenURL.drive(strongSelf.rx.presentSafariVC).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldShare.drive(strongSelf.rx.presentActivityVC).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldSendFeedback.map(to: feedback).present().disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldRouteTutorial.map(to: tutorial).present().disposed(by: vc.rx.disposeBag)
        })
    }
    
    public func events() -> Route<EventsContainerViewController> {
        return route().configure({ [weak self, eventFilters = eventFilters()] vc in
            guard let strongSelf = self else { return }
            vc.viewModel?.shouldRouteFilters.map(to: eventFilters).present().disposed(by: vc.rx.disposeBag)
            vc.viewModel?.listEventsViewModel.shouldOpenURL.drive(strongSelf.rx.presentSafariVC).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.mapEventsViewModel.eventDescriptionViewModel.shouldOpenURL.drive(strongSelf.rx.presentSafariVC).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.mapEventsViewModel.eventDescriptionViewModel.shouldShare.drive(strongSelf.rx.presentActivityVC).disposed(by: vc.rx.disposeBag)
        }).embedInNavigation(NavigationControllerFactory.`default`())
    }
    
    public func teams() -> Route<TeamsViewController> {
        return route().configure({ [playerDescription = playerDescription()] vc in
            vc.viewModel?.shouldRouteProfile.drive(onNext: { [weak vc] in vc?.tabBarController?.setSelectedViewController(ProfileViewController.self) }).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldRouteDescription.map(playerDescription.buildViewModel).present().disposed(by: vc.rx.disposeBag)
            vc.viewModel?.playersBannerViewModel.shouldRouteDescription.map(playerDescription.buildViewModel).present().disposed(by: vc.rx.disposeBag)
        })
    }
    
    public func players() -> Route<PlayersViewController> {
        return route().configure({ [playerDescription = playerDescription()] vc in
            vc.viewModel?.shouldRouteProfile.drive(onNext: { [weak vc] in vc?.tabBarController?.setSelectedViewController(ProfileViewController.self) }).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldRouteDescription.map(playerDescription.buildViewModel).present().disposed(by: vc.rx.disposeBag)
        })
    }
    
    public func eventFilters() -> Route<EventsFilterViewController> {
        return route().configure({ [picekrVC = picekr(), datePicekrVC = datePicekr()] vc in
            guard let nvc = vc.navigationController else { return }
            nvc.addMotionTransition(.zoom)
            vc.viewModel?.shouldClose.map(to: MotionTransitionAnimationType.zoomOut).drive(nvc.rx.motiondClose).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldRoutePicker.map{ picekrVC.with(viewModel: $0) }.present().disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldRouteDatePicker.map{ datePicekrVC.with(viewModel: $0) }.present().disposed(by: vc.rx.disposeBag)
        }).embedInNavigation(NavigationControllerFactory.`default`())
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
        return route().configure({ [weak self] vc in
            guard let strongSelf = self, let nvc = vc.navigationController else { return }
            nvc.addMotionTransition(.zoomSlide(direction: .left))
            vc.viewModel?.shouldClose.map(to: MotionTransitionAnimationType.zoomSlide(direction: .right)).drive(nvc.rx.motiondClose).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.alertViewModel.drive(strongSelf.rx.presentAlertVM).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldShare.drive(strongSelf.rx.presentActivityVC).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldOpenURL.drive(strongSelf.rx.presentSafariVC).disposed(by: vc.rx.disposeBag)
        }).embedInNavigation(NavigationControllerFactory.clear())
    }
    
    public func newsDescription() -> Route<NewsDescriptionViewController> {
        return route().configure({ [weak self, imageViewer = imageViewer()] vc in
            guard let strongSelf = self, let nvc = vc.navigationController else { return }
            nvc.addMotionTransition(.zoomSlide(direction: .left))
            vc.viewModel?.shouldClose.map(to: MotionTransitionAnimationType.zoomSlide(direction: .right)).drive(nvc.rx.motiondClose).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldRouteImageViewer.map(imageViewer.buildViewModel).present().disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldShare.drive(strongSelf.rx.presentActivityVC).disposed(by: vc.rx.disposeBag)
        }).embedInNavigation(NavigationControllerFactory.clear())
    }
    
    public func imageViewer() -> Route<ImageViewerViewController> {
        return route().configure({ [weak self] vc in
            guard let strongSelf = self, let nvc = vc.navigationController else { return }
            nvc.addMotionTransition(.zoom)
            vc.viewModel?.shouldClose.map(to: MotionTransitionAnimationType.zoomOut).drive(nvc.rx.motiondClose).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldOpenURL.drive(strongSelf.rx.presentSafariVC).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.alertViewModel.drive(strongSelf.rx.presentAlertVM).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldRouteAppSettings.drive(onNext:{ try? strongSelf.deviceRouter.openSettings() }).disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldShare.drive(strongSelf.rx.presentActivityVC).disposed(by: vc.rx.disposeBag)
        }).embedInNavigation(NavigationControllerFactory.`default`())
    }
    
    public func favoritePlayers() -> Route<FavoritePlayersViewController> {
        return route().configure({ [playerDescription = playerDescription()] vc in
            vc.viewModel?.shouldRouteDescription.map(playerDescription.buildViewModel).present().disposed(by: vc.rx.disposeBag)
            vc.viewModel?.shouldClose.map(to: true).drive(vc.rx.close).disposed(by: vc.rx.disposeBag)
        })
    }
    
    public func skins() -> Route<SkinsViewController> {
        return route().configure({ vc in
            vc.viewModel?.shouldClose.map(to: true).drive(vc.rx.close).disposed(by: vc.rx.disposeBag)
        })
    }
    
    public func feedback() -> Route<FeedbackViewController> {
        return route().configure({ [weak self] vc in
            vc.transitioningDelegate = self?.alertAnimator
            vc.modalPresentationStyle = .custom
            vc.viewModel?.shouldClose.map(to: true).drive(vc.rx.close).disposed(by: vc.rx.disposeBag)
        })
    }
    
    private func route<T: UIViewController>() -> Route<T> where T: ViewModelHolderProtocol {
        return Route<T>(router: appRouter, viewFactory: viewFactory, viewModelFactory: viewModelFactory).fromFactory().buildViewModel()
    }
}
