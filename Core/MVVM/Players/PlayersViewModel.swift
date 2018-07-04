//
//  PlayersViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol PlayersViewModel {
    var playersPaginator: Paginator<PlayerPreviewViewModel> { get }
    var messageViewModel: Driver<MessageViewModel> { get }
    var profileTrigger: BehaviorRelay<Void> { get }
    var shouldRouteProfile: Driver<Void> { get }
}

public final class PlayersViewModelImpl: PlayersViewModel, ReactiveCompatible {
    public let playersPaginator: Paginator<PlayerPreviewViewModel>
    public let messageViewModel: Driver<MessageViewModel>
    public let profileTrigger = BehaviorRelay(value: ())
    public let shouldRouteProfile: Driver<Void>
    
    public init(playersService: PlayersAPIService) {
        func remapToViewModels(page: Page<PlayerPreview>) -> Page<PlayerPreviewViewModel> {
            return Page.new(content: page.content.map{ player in
                return PlayerPreviewViewModelImpl(player: player)
            }, index: page.index, totalPages: page.totalPages)
        }
        
        let message = PublishSubject<MessageViewModel>()
        messageViewModel = message.asDriver(onErrorJustReturn: MessageViewModelFactory.error())
        playersPaginator = Paginator(factory: { playersService.getPlayers(forPage: $0).success().map(remapToViewModels).asObservable() })
        shouldRouteProfile = profileTrigger.asDriver()
        playersPaginator.error.map{ MessageViewModelFactory.error(description: $0.localizedDescription) }.drive(message).disposed(by: rx.disposeBag)
    }
}
