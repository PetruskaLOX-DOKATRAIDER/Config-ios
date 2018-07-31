//
//  NewsViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol NewsViewModel {
    var newsPaginator: Paginator<NewsItemViewModel> { get }
    var messageViewModel: Driver<MessageViewModel> { get }
    var profileTrigger: BehaviorSubject<Void> { get }
    var shouldRouteProfile: Driver<Void> { get }
    var shouldRouteNewsDescription: Driver<Int> { get }
}

public final class NewsViewModelImpl: NewsViewModel {
    public let newsPaginator: Paginator<NewsItemViewModel>
    public let messageViewModel: Driver<MessageViewModel>
    public let profileTrigger = BehaviorSubject<Void>()
    public let shouldRouteProfile: Driver<Void>
    public let shouldRouteNewsDescription: Driver<Int>
    
    public init() {

    }
}
