import Dip

public protocol ViewModelFactoryType {
    func buildViewModel<T>() throws -> T
    func buildViewModel<T, ARG>(arg: ARG) throws -> T
    func buildViewModel<T, ARG, ARG2>(arg: ARG, arg2: ARG2) throws -> T
}

extension DependencyContainer: ViewModelFactoryType {
    public func buildViewModel<T>() throws -> T {
        return try resolve()
    }

    public func buildViewModel<T, ARG>(arg: ARG) throws -> T {
        return try resolve(arguments: arg)
    }
    
    public func buildViewModel<T, ARG, ARG2>(arg: ARG, arg2: ARG2) throws -> T {
        return try resolve(arguments: arg, arg2)
    }
}
