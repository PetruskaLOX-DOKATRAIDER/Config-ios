//
//  EventsService.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public enum EventsServiceError: Error {
    case serverError(Error)
    case noData
    case unknown
}

public protocol EventsService: AutoMockable {
    func getEvents(forPage page: Int) -> Driver<Result<Page<Event>, EventsServiceError>>
}

public final class EventsServiceImpl: EventsService, ReactiveCompatible {
    private let reachabilityService: ReachabilityService
    private let eventsAPIService: EventsAPIService
    private let eventsStorage: EventsStorage
    
    public init(
        reachabilityService: ReachabilityService,
        eventsAPIService: EventsAPIService,
        eventsStorage: EventsStorage
    ) {
        self.reachabilityService = reachabilityService
        self.eventsAPIService = eventsAPIService
        self.eventsStorage = eventsStorage
    }

    public func getEvents(forPage page: Int) -> Driver<Result<Page<Event>, EventsServiceError>> {
        return reachabilityService.connection != .none ? loadAndSaveEvents(forPage: page) : getStoredEvents()
    }
    
    private func loadAndSaveEvents(forPage page: Int) -> Driver<Result<Page<Event>, EventsServiceError>> {
        let request = eventsAPIService.getEvents(forPage: page)
        let noData = request.success().filter{ $0.content.isEmpty }.toVoid()
        let successData = request.success().filter{ $0.content.isNotEmpty }
        
        successData.map{ $0.content }.drive(onNext: { [weak self] newEvents in
            self?.eventsStorage.update(withNewEvents: newEvents, completion: nil)
        }).disposed(by: rx.disposeBag)
        
    
        return .merge(
            successData.map{ Result(value: $0) },
            noData.map(to: Result(error: .noData)),
            request.failure().map{ Result(error: .serverError($0.localizedDescription)) }
        )
    }
    
    private func getStoredEvents() -> Driver<Result<Page<Event>, EventsServiceError>> {
        return Observable<Result<Page<Event>, EventsServiceError>>.create{ [weak self] observer in
            self?.eventsStorage.fetchEvents(completion: { events in
                observer.onNext(Result(value: .new(content: events, index: 1, totalPages: 1)))
                observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: Result(error: .unknown))
    }
}
