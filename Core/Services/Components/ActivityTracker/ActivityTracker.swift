//
//  ActivityTracker.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// https://github.com/ReactiveX/RxSwift/blob/master/RxExample/RxExample/Services/ActivityIndicator.swift
private struct ActivityToken<E> : ObservableConvertibleType, Disposable {
    private let _source: Observable<E>
    private let _dispose: Cancelable
    
    init(source: Observable<E>, disposeAction: @escaping () -> Void) {
        _source = source
        _dispose = Disposables.create(with: disposeAction)
    }
    
    func dispose() {
        _dispose.dispose()
    }
    
    func asObservable() -> Observable<E> {
        return _source
    }
}

/**
 Enables monitoring of sequence computation.
 If there is at least one sequence computation in progress, `true` will be sent.
 When all activities complete `false` will be sent.
 */

public protocol ActivityTrackingServiceType {
    func trackActivityOf<O: ObservableConvertibleType>(_ source: O) -> Observable<O.E>
    func asSharedSequence() -> Driver<Bool>
}

open class ActivityTracker: SharedSequenceConvertibleType, ActivityTrackingServiceType {
    public typealias E = Bool
    public typealias SharingStrategy = DriverSharingStrategy
    
    private let _lock = NSRecursiveLock()
    private let _variable = Variable(0)
    private let _loading: SharedSequence<SharingStrategy, Bool>
    
    public init() {
        _loading = _variable.asDriver()
            .map { $0 > 0 }
            .distinctUntilChanged()
    }
    
    public func trackActivityOf<O: ObservableConvertibleType>(_ source: O) -> Observable<O.E> {
        return Observable.using({ () -> ActivityToken<O.E> in
            self.increment()
            return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
        }, observableFactory: { t in
            return t.asObservable()
        })
    }
    
    private func increment() {
        _lock.lock()
        _variable.value += 1
        _lock.unlock()
    }
    
    private func decrement() {
        _lock.lock()
        _variable.value -= 1
        _lock.unlock()
    }
    
    public func asSharedSequence() -> Driver<Bool> {
        return _loading
    }
}

extension ObservableConvertibleType {
    public func trackBy(_ activityIndicator: ActivityTrackingServiceType?) -> Observable<E> {
        return activityIndicator.map{ $0.trackActivityOf(self) } ?? self.asObservable()
    }
}
//SharedSequence<DriverSharingStrategy, E>
extension SharedSequenceConvertibleType where Self.SharingStrategy == DriverSharingStrategy {
    public func trackBy(_ activityIndicator: ActivityTrackingServiceType?) -> Driver<E> { // lets hope there would be no errors inside
        return activityIndicator.map{ $0.trackActivityOf(self.asObservable()).asDriver(onErrorDriveWith: .empty()) } ?? self.asDriver()
    }
}

infix operator >>: AdditionPrecedence
public func >><T, R>(_ selector: @escaping (T) -> Driver<R>, tracker: ActivityTrackingServiceType? ) -> (T) -> Driver<R> {
    return {
        return selector($0).trackBy(tracker)
    }
}

public protocol WorkerType {
    var needsTracking: Bool { get }
    var isWorking: Driver<Bool> { get }
}

extension WorkerType {
    public var needsTracking: Bool { return true }
}

// TODO: this part should be rewritten in swift 4.1
public protocol WorkerHolder {
    func onWorkerReceived() -> Observable<(WorkerType, DisposeBag)>
}

public extension WorkerHolder where Self: ViewModelHolderProtocol, Self: UIViewController {
    public func onWorkerReceived() -> Observable<(WorkerType, DisposeBag)> {
        return rx.viewModelDidUpdate.map{ (viewModel, bag) -> (WorkerType, DisposeBag)? in
            guard let worker = viewModel as? WorkerType else { return nil }
            return (worker, bag)
            }.filterNil()
    }
}
