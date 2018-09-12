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
    var shouldRouteDescription: Driver<NewsPreview> { get }
    var shouldShare: Driver<ShareItem> { get }
}

public final class NewsViewModelImpl: NewsViewModel, ReactiveCompatible {
    public let newsPaginator: Paginator<NewsItemViewModel>
    public let messageViewModel: Driver<MessageViewModel>
    public let profileTrigger = PublishSubject<Void>()
    public let shouldRouteProfile: Driver<Void>
    public let shouldRouteDescription: Driver<NewsPreview>
    public let shouldShare: Driver<ShareItem>
    
    public init(newsService: NewsService) {
        let route = PublishSubject<NewsPreview?>()
        let share = PublishSubject<URL?>()
        shouldRouteDescription = route.asDriver(onErrorJustReturn: nil).filterNil()
        shouldShare = share.asDriver(onErrorJustReturn: nil).filterNil().map{ ShareItem(url: $0) }
        func remapToViewModels(page: Page<NewsPreview>) -> Page<NewsItemViewModel> {
            return Page.new(
                content: page.content.map{ news in
                    let vm = NewsItemViewModelImpl(news: news)
                    vm.selectionTrigger.asDriver(onErrorJustReturn: ()).map{ news }.drive(route).disposed(by: vm.rx.disposeBag)
                    vm.shareTrigger.asDriver(onErrorJustReturn: ()).map{ news.detailsURL }.drive(share).disposed(by: vm.rx.disposeBag)
                    return vm
                },
                index: page.index,
                totalPages: page.totalPages
            )
        }
        
        
        newsPaginator = Paginator(factory:{ newsService.getPreview(page: $0).asObservable().map{ try $0.dematerialize() }.map(remapToViewModels) })
        shouldRouteProfile = profileTrigger.asDriver(onErrorJustReturn: ())
        messageViewModel = newsPaginator.error.map{ MessageViewModelImpl.error(description: $0.localizedDescription) }
    }
}
