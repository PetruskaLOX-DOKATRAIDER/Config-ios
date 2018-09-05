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
    var profileTrigger: PublishSubject<Void> { get }
    var shouldRouteProfile: Driver<Void> { get }
    var shouldRouteNewsDescription: Driver<NewsPreview> { get }
}

public final class NewsViewModelImpl: NewsViewModel, ReactiveCompatible {
    public let newsPaginator: Paginator<NewsItemViewModel>
    public let messageViewModel: Driver<MessageViewModel>
    public let profileTrigger = PublishSubject<Void>()
    public let shouldRouteProfile: Driver<Void>
    public let shouldRouteNewsDescription: Driver<NewsPreview>
    
    public init(newsService: NewsService) {
        let route = PublishSubject<NewsPreview?>()
        shouldRouteNewsDescription = route.asDriver(onErrorJustReturn: nil).filterNil()
        func remapToViewModels(page: Page<NewsPreview>) -> Page<NewsItemViewModel> {
            return Page.new(
                content: page.content.map{ news in
                    let vm = NewsItemViewModelImpl(news: news)
                    vm.selectionTrigger.asDriver(onErrorJustReturn: ()).map{ news }.drive(route).disposed(by: vm.rx.disposeBag)
                    return vm
                },
                index: page.index,
                totalPages: page.totalPages
            )
        }
        
        let message = PublishSubject<MessageViewModel>()
        messageViewModel = message.asDriver(onErrorJustReturn: MessageViewModelImpl.error())
        newsPaginator = Paginator(factory: { newsService.getNewsPreview(forPage: $0).success().map(remapToViewModels).asObservable() })
        shouldRouteProfile = profileTrigger.asDriver(onErrorJustReturn: ())
        newsPaginator.error.map{ MessageViewModelImpl.error(description: $0.localizedDescription) }.drive(message).disposed(by: rx.disposeBag)
    }
}
