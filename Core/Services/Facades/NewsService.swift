//
//  NewsService.swift
//  Core
//
//  Created by Oleg Petrychuk on 31.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public enum NewsServiceError: Error {
    case serverError(Error)
    case noData
    case unknown
}

public protocol NewsService {
    func getNewsPreview(forPage page: Int) -> DriverResult<Page<NewsPreview>, NewsServiceError>
    func getNewsDescription(byID id: Int) -> DriverResult<NewsDescription, NewsServiceError>
}

public final class NewsServiceImpl: NewsService, ReactiveCompatible {
    private let reachabilityService: ReachabilityService
    private let newsAPIService: NewsAPIService
    private let newsStorage: NewsStorage
    
    public init(
        reachabilityService: ReachabilityService,
        newsAPIService: NewsAPIService,
        newsStorage: NewsStorage
    ) {
        self.reachabilityService = reachabilityService
        self.newsAPIService = newsAPIService
        self.newsStorage = newsStorage
    }

    public func getNewsPreview(forPage page: Int) -> DriverResult<Page<NewsPreview>, NewsServiceError> {
        guard reachabilityService.connection != .none else { return getStoredNewsPreview() }
        let request = getRemoteNewsPreview(forPage: page)
        return .merge(request.filter{ $0.value == nil }, updateNewsPreview(request.success()))
    }
    
    public func getNewsDescription(byID id: Int) -> DriverResult<NewsDescription, NewsServiceError> {
        guard reachabilityService.connection != .none else { return getStoredNewsDescription(byID: id) }
        let request = getRemoteNewsDescription(byID: id)
        return .merge(request.filter{ $0.value == nil }, updateNewsDescription(request.success()))
    }
    
    private func getRemoteNewsPreview(forPage page: Int) -> DriverResult<Page<NewsPreview>, NewsServiceError> {
        let request = newsAPIService.getNewsPreview(forPage: page)
        let noData = request.success().filter{ $0.content.isEmpty }.toVoid()
        let successData = request.success().filter{ $0.content.isNotEmpty }
        return .merge(
            successData.map{ Result(value: $0) },
            noData.map(to: Result(error: .noData)),
            request.failure().map{ Result(error: .serverError($0.localizedDescription)) }
        )
    }
    
    private func updateNewsPreview(_ remoteNewsPreview: Driver<Page<NewsPreview>>) -> DriverResult<Page<NewsPreview>, NewsServiceError> {
        return remoteNewsPreview.flatMapLatest{ [weak self] page -> Driver<Page<NewsPreview>> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.newsStorage.updateNewsPreview(withNewNews: page.content).map(to: page)
        }.map{ Result(value: $0) }
    }
    
    private func getStoredNewsPreview() -> DriverResult<Page<NewsPreview>, NewsServiceError> {
        let data = newsStorage.fetchNewsPreview()
        return .merge(
            data.map{ Result(value: Page.new(content: $0, index: 1, totalPages: 1)) },
            data.filterEmpty().map(to: Result(error: .noData))
        )
    }
    
    private func getRemoteNewsDescription(byID id: Int) -> DriverResult<NewsDescription, NewsServiceError> {
        let request = newsAPIService.getNewsDescription(byID: id)
        return .merge(
            request.success().map{ Result(value: $0) },
            request.failure().map{ Result(error: .serverError($0.localizedDescription)) }
        )
    }
    
    private func updateNewsDescription(_ remoteNewsDescription: Driver<NewsDescription>) -> DriverResult<NewsDescription, NewsServiceError> {
        return remoteNewsDescription.flatMapLatest { [weak self] news -> Driver<NewsDescription> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.newsStorage.updateNewsDescription(withNewNews: news).map(to: news)
        }.map{ Result(value: $0) }
    }
    
    private func getStoredNewsDescription(byID id: Int) -> DriverResult<NewsDescription, NewsServiceError> {
        let data = newsStorage.fetchNewsDescription(byID: id)
        return Driver.merge(
            data.filter{ $0 == nil }.map(to: Result(error: .noData)),
            data.filterNil().map{ Result(value: $0) }
        )
    }
}
