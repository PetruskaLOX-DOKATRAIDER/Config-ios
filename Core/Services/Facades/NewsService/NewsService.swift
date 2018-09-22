//
//  NewsService.swift
//  Core
//
//  Created by Oleg Petrychuk on 31.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public enum NewsServiceError: Error {
    case serverError(Error)
    case unknown
}

public protocol NewsService: AutoMockable {
    func getPreview(page: Int) -> DriverResult<Page<NewsPreview>, NewsServiceError>
    func getDescription(news id: Int) -> DriverResult<NewsDescription, NewsServiceError>
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

    public func getPreview(page: Int) -> DriverResult<Page<NewsPreview>, NewsServiceError> {
        guard reachabilityService.connection != .none else { return getStoredPreview() }
        let request = getRemoteNewsPreview(forPage: page)
        return .merge(request.filter{ $0.value == nil }, updatePreview(request.success()))
    }
    
    public func getDescription(news id: Int) -> DriverResult<NewsDescription, NewsServiceError> {
        guard reachabilityService.connection != .none else { return getStoredDescription(news: id) }
        let request = getRemoteDescription(news: id)
        return .merge(request.filter{ $0.value == nil }, updateDescription(request.success()))
    }
    
    private func getRemoteNewsPreview(forPage page: Int) -> DriverResult<Page<NewsPreview>, NewsServiceError> {
        let request = newsAPIService.get(page: page)
        return .merge(
            request.success().map{ Result(value: $0) },
            request.failure().map{ Result(error: .serverError($0.localizedDescription)) }
        )
    }
    
    private func updatePreview(_ remote: Driver<Page<NewsPreview>>) -> DriverResult<Page<NewsPreview>, NewsServiceError> {
        return remote.flatMapLatest{ [weak self] page -> Driver<Page<NewsPreview>> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.newsStorage.updatePreview(withNew: page.content).map(to: page)
        }.map{ Result(value: $0) }
    }
    
    private func getStoredPreview() -> DriverResult<Page<NewsPreview>, NewsServiceError> {
        return newsStorage.getPreview().map{ Result(value: Page.new(content: $0, index: 1, totalPages: 1)) }
    }
    
    private func getRemoteDescription(news id: Int) -> DriverResult<NewsDescription, NewsServiceError> {
        let request = newsAPIService.get(news: id)
        return .merge(
            request.success().map{ Result(value: $0) },
            request.failure().map{ Result(error: .serverError($0.localizedDescription)) }
        )
    }
    
    private func updateDescription(_ remote: Driver<NewsDescription>) -> DriverResult<NewsDescription, NewsServiceError> {
        return remote.flatMapLatest { [weak self] news -> Driver<NewsDescription> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.newsStorage.updateDescription(withNew: news).map(to: news)
        }.map{ Result(value: $0) }
    }
    
    private func getStoredDescription(news id: Int) -> DriverResult<NewsDescription, NewsServiceError> {
        return newsStorage.getDescription(news: id).filterNil().map{ Result(value: $0) }
    }
}


extension NewsServiceError: Equatable {
    public static func == (lhs: NewsServiceError, rhs: NewsServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.serverError, .serverError): return true
        case (.unknown, .unknown): return true
        default: return false
        }
    }
}
