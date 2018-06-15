import RxCocoa
import AppRouter

open class Router: ReactiveCompatible {
    public let viewFactory: ViewFactoryType
    public let viewModelFactory: ViewModelFactoryType
    public let router: AppRouterType
    
    public init(router: AppRouterType, viewFactory: ViewFactoryType, viewModelFactory: ViewModelFactoryType) {
        self.router = router
        self.viewFactory = viewFactory
        self.viewModelFactory = viewModelFactory
    }

    public func splash() -> AppRouter.Presenter.Configuration<UIViewController> {
        return UIViewController.presenter().from {
            try UIStoryboard("LaunchScreen", bundle: Bundle.core).instantiateInitialViewController() ?? AppRouter.Presenter.Errors.failedToConstructSourceController.rethrow()
        }
    }
    
    public func unsupportedVersionAlert(marketURL: URL? = nil) -> AppRouter.Presenter.Configuration<UIAlertController> {
        return UIAlertController.presenter().from {
            UIAlertController(title: "Unsupported application version!",
                              message: "Please visit Distribution Site and update to continue using this application.", preferredStyle: .alert)
        }.configure {
            if let updateURL = marketURL, UIApplication.shared.canOpenURL(updateURL) {
                print(updateURL)
                $0.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil ))
                $0.addAction(UIAlertAction(title: "Update", style: .destructive, handler: { _ in
                    UIApplication.shared.open(updateURL)
                }))
            } else {
                $0.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil ))
            }
        }
    }
    
    func route<T: UIViewController>() -> Route<T> where T: ViewModelHolderProtocol {
        return Route<T>(router: router, viewFactory: viewFactory, viewModelFactory: viewModelFactory).fromFactory().buildViewModel()
    }
}
