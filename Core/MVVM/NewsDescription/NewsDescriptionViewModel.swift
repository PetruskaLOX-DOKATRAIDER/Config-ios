//
//  NewsDescriptionViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 01.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol NewsContentItemViewModel {}
extension NewsTextContentItemViewModelImpl: NewsContentItemViewModel {}
extension NewsImageContentItemViewModelImpl: NewsContentItemViewModel {}

public protocol NewsDescriptionViewModel {
    var title: Driver<String> { get }
    var subtitle: Driver<String> { get }
    var description: Driver<String> { get }
    var coverImageURL: Driver<URL?> { get }
    var content: Driver<[NewsContentItemViewModel]> { get }
    var refreshTrigger: PublishSubject<Void> { get }
    var isDataAvaliable: Driver<Bool>  { get }
    var isWorking: Driver<Bool> { get }
    var messageViewModel: Driver<MessageViewModel> { get }
    
    var detailsTrigger: PublishSubject<Void> { get }
    var shareTrigger: PublishSubject<Void> { get }
    var closeTrigger: PublishSubject<Void> { get }
    
    var shouldRouteImageViewer: Driver<URL?> { get }
    var shouldClose: Driver<Void> { get }
}

public final class NewsDescriptionViewModelImpl: NewsDescriptionViewModel, ReactiveCompatible {
    public let title: Driver<String>
    public let subtitle: Driver<String>
    public let description: Driver<String>
    public let coverImageURL: Driver<URL?>
    public let content: Driver<[NewsContentItemViewModel]>
    public let isDataAvaliable: Driver<Bool>
    public let isWorking: Driver<Bool>
    public let refreshTrigger = PublishSubject<Void>()
    public let messageViewModel: Driver<MessageViewModel>
    
    public let detailsTrigger = PublishSubject<Void>()
    public let shareTrigger = PublishSubject<Void>()
    public let closeTrigger = PublishSubject<Void>()
    
    public let shouldRouteImageViewer: Driver<URL?>
    public let shouldClose: Driver<Void>
    
    public init(
        news: NewsPreview,
        newsService: NewsService
    ) {
        let openImage = PublishSubject<URL?>()
        shouldRouteImageViewer = openImage.asDriver(onErrorJustReturn: nil)
        
        func remapToViewModel(_ news: NewsDescription) -> [NewsContentItemViewModel] {
            var contentVMs = [NewsContentItemViewModel]()
            news.content.forEach { content in
                if let imageContent = content as? NewsImageContent {
                    let imageContentVM = NewsImageContentItemViewModelImpl(newsImageContent: imageContent)
                    imageContentVM.selectionTrigger.asDriver(onErrorJustReturn: ()).map(to: imageContent.coverImageURL).drive(openImage).disposed(by: imageContentVM.rx.disposeBag)
                    contentVMs.append(imageContentVM)
                } else if let imageContent = content as? NewsTextContent {
                    contentVMs.append(NewsTextContentItemViewModelImpl(newsTextContent: imageContent))
                }
            }
            return contentVMs
        }
        
        let newsRequest = refreshTrigger.asDriver(onErrorJustReturn: ()).flatMapLatest{ newsService.getNewsDescription(byID: news.id) }
        title = newsRequest.success().map(to: news.title).startWith("")
        coverImageURL = newsRequest.success().map(to: news.coverImageURL).startWith(nil)
        subtitle = newsRequest.success().map{ $0.title }.startWith("")
        description = newsRequest.success().map{
            "\(Strings.Newsdescription.posted) \(DateFormatters.default.string(from: $0.date)) \(Strings.Newsdescription.by) \($0.author)"
        }.startWith("")
        content = newsRequest.success().map{ remapToViewModel($0) }.startWith([])
        isDataAvaliable = Driver.merge(newsRequest.success().map(to: true), newsRequest.failure().map(to: false)).startWith(false)
        isWorking = Driver.merge(
            refreshTrigger.asDriver(onErrorJustReturn: ()).map(to: true),
            newsRequest.map(to: false)
        ).startWith(false)
        messageViewModel = newsRequest.failure().map(to: MessageViewModelFactory.error())
        shouldClose = closeTrigger.asDriver(onErrorJustReturn: ())
    }
}
