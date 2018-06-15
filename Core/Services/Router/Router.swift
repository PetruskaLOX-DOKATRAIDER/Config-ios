import RxCocoa
import AppRouter

open class Router: ReactiveCompatible {
    public let router: AppRouterType
    
    public init(router: AppRouterType) {
        self.router = router
    }
}
