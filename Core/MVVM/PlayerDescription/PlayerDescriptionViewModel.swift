//
//  PlayerDescriptionViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol PlayerDescriptionViewModel {
    var playerInfoViewModel: PlayerInfoViewModel { get }
    var messageViewModel: Driver<MessageViewModel> { get }
    var isWorking: Driver<Bool> { get }
    var shoudShowAlert: Driver<AlertViewModel> { get }
    var optionsTrigger: PublishSubject<Void> { get }
    var detailsTrigger: PublishSubject<Void> { get }
    var sendCFGTrigger: PublishSubject<Void> { get }
    var refreshTrigger: PublishSubject<Void> { get }
    var closeTrigger: PublishSubject<Void> { get }
    var shouldShare: Driver<ShareItem> { get }
    var shouldClose: Driver<Void> { get }
}



public final class PlayerDescriptionViewModelImpl: PlayerDescriptionViewModel {
    public let playerInfoViewModel: PlayerInfoViewModel
    public let messageViewModel: Driver<MessageViewModel>
    public let isWorking: Driver<Bool>
    public let shoudShowAlert: Driver<AlertViewModel>
    public let optionsTrigger = PublishSubject<Void>()
    public let detailsTrigger = PublishSubject<Void>()
    public let sendCFGTrigger = PublishSubject<Void>()
    public let refreshTrigger = PublishSubject<Void>()
    public let closeTrigger = PublishSubject<Void>()
    public let shouldShare: Driver<ShareItem>
    public let shouldClose: Driver<Void>

    public init(
        playerID: Int,
        playersService: PlayersService,
        pasteboardService: PasteboardService
    ) {
        let request = playersService.getPlayerDescription(byPlayerID: playerID)
        let player = refreshTrigger.asDriver(onErrorJustReturn: ()).flatMapLatest{ request }.success()
        let error = refreshTrigger.asDriver(onErrorJustReturn: ()).flatMapLatest{ request }.failure()
    
        playerInfoViewModel = PlayerInfoViewModelImpl(player: player)
        
        isWorking = Driver.merge(
            refreshTrigger.asDriver(onErrorJustReturn: ()).map(to: true),
            player.map(to: false)
        ).startWith(false)
        
        shouldClose = closeTrigger.asDriver(onErrorJustReturn: ())
        
        let copyCFG = PublishSubject<Void>()
        let shareCFG = PublishSubject<Void>()
        let addToFavorites = PublishSubject<Void>()
        let removeFromFavorites = PublishSubject<Void>()
      
        let cfg = copyCFG.withLatestFrom(player.map{ $0.configURL }).asDriver(onErrorJustReturn: nil).filterNil()
        let copiedCFG = cfg.map{ pasteboardService.save($0.absoluteString) }
        shouldShare = cfg.map{ ShareItem(url: $0) }
        
        let addedSuccess = addToFavorites.asDriver(onErrorJustReturn: ())
            .flatMapLatest{ playersService.addPlayerToFavorites(byID: playerID).success() }
        let removedSuccess = removeFromFavorites.asDriver(onErrorJustReturn: ())
            .flatMapLatest{ playersService.removePlayerFromFavorites(byID: playerID).success() }
        
        messageViewModel = Driver.merge(
            error.map(to: MessageViewModelImpl.error()),
            addedSuccess.map(to: MessageViewModelImpl(title: Strings.PlayerDescription.options, description: Strings.PlayerDescription.addedFavoriteMessage)),
            removedSuccess.map(to: MessageViewModelImpl(title: Strings.PlayerDescription.options, description: Strings.PlayerDescription.removedFavoriteMessage)),
            copiedCFG.map(to: MessageViewModelImpl(title: Strings.PlayerDescription.options, description: Strings.PlayerDescription.copiedMessage))
        ).map{ $0 as MessageViewModel }

        let isPlayerFavorite = optionsTrigger.asDriver(onErrorJustReturn: ())
            .flatMapLatest{ playersService.isPlayerInFavorites(playerID: playerID).success() }
        
        shoudShowAlert = isPlayerFavorite.map{ isPlayerFavorite in
            let addRemove = isPlayerFavorite
                ? AlertActionViewModelImpl(title: Strings.PlayerDescription.removeFromFavorites, action: removeFromFavorites)
                : AlertActionViewModelImpl(title: Strings.PlayerDescription.addToFavorites, action: addToFavorites)
    
            return AlertViewModelImpl(
                title: Strings.PlayerDescription.options,
                style: .actionSheet,
                actions: [
                    AlertActionViewModelImpl(title: Strings.PlayerDescription.copyCfg, action: copyCFG),
                    AlertActionViewModelImpl(title: Strings.PlayerDescription.shareCfg, action: shareCFG),
                    addRemove,
                    AlertActionViewModelImpl(title: Strings.PlayerDescription.cancel, style: .destructiveActionStyle)
                ]
            )
        }
    }
}
