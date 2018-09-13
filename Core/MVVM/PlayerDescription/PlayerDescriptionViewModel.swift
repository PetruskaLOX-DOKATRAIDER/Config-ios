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
    var shouldShare: Driver<ShareItem> { get }
    var optionsTrigger: PublishSubject<Void> { get }
    var detailsTrigger: PublishSubject<Void> { get }
    var sendCFGTrigger: PublishSubject<Void> { get }
    var refreshTrigger: PublishSubject<Void> { get }
    var closeTrigger: PublishSubject<Void> { get }
    var shouldClose: Driver<Void> { get }
}

public final class PlayerDescriptionViewModelImpl: PlayerDescriptionViewModel, ReactiveCompatible {
    public let playerInfoViewModel: PlayerInfoViewModel
    public let messageViewModel: Driver<MessageViewModel>
    public let isWorking: Driver<Bool>
    public let shoudShowAlert: Driver<AlertViewModel>
    public let shouldShare: Driver<ShareItem>
    public let optionsTrigger = PublishSubject<Void>()
    public let detailsTrigger = PublishSubject<Void>()
    public let sendCFGTrigger = PublishSubject<Void>()
    public let refreshTrigger = PublishSubject<Void>()
    public let closeTrigger = PublishSubject<Void>()
    public let shouldClose: Driver<Void>

    public init(
        player id: Int,
        playersService: PlayersService,
        pasteboardService: PasteboardService,
        userStorage: UserStorage,
        emailService: EmailService
    ) {
        let request = playersService.getDescription(player: id)
        let error = refreshTrigger.asDriver(onErrorJustReturn: ()).flatMapLatest{ request }.failure()
        let player = refreshTrigger.asDriver(onErrorJustReturn: ()).flatMapLatest{ request }.success()
        playerInfoViewModel = PlayerInfoViewModelImpl(player: player)
        shouldClose = closeTrigger.asDriver(onErrorJustReturn: ())
        isWorking = Driver.merge(
            refreshTrigger.asDriver(onErrorJustReturn: ()).map(to: true),
            player.map(to: false)
        ).startWith(false)
        
        let copyCFG = PublishSubject<Void>()
        let shareCFG = PublishSubject<Void>()
        let cfg = player.map{ $0.configURL }.filterNil()
        let copiedCFG = copyCFG.withLatestFrom(cfg).map{ pasteboardService.save($0.absoluteString) }.asDriver(onErrorJustReturn: ())
        shouldShare = shareCFG.asDriver(onErrorJustReturn: ()).withLatestFrom(cfg).map{ ShareItem(url: $0) }
    
        let addToFavorites = PublishSubject<Void>()
        let removeFromFavorites = PublishSubject<Void>()
        let addedSuccess = addToFavorites.asDriver(onErrorJustReturn: ())
            .flatMapLatest{ playersService.add(favourite: id).success() }
        let removedSuccess = removeFromFavorites.asDriver(onErrorJustReturn: ())
            .flatMapLatest{ playersService.remove(favourite: id).success() }
        
        let sendCFG = sendCFGTrigger
            .asDriver(onErrorJustReturn: ())
            .withLatestFrom(cfg)
            .flatMapLatest{ emailService.send(withInfo:
                EmailInfo(recipient: userStorage.email.value ?? "", subject: Strings.PlayerDescription.sendCfg, message: $0.absoluteString)
            )}
        let noAccount = sendCFG.failure().filter{ $0 == .noAccount }
        
        
        messageViewModel = Driver.merge(
            error.map(to: MessageViewModelImpl.error()),
            addedSuccess.map(to: MessageViewModelImpl(title: Strings.PlayerDescription.options, description: Strings.PlayerDescription.addedFavoriteMessage)),
            removedSuccess.map(to: MessageViewModelImpl(title: Strings.PlayerDescription.options, description: Strings.PlayerDescription.removedFavoriteMessage)),
            copiedCFG.map(to: MessageViewModelImpl(title: Strings.PlayerDescription.options, description: Strings.PlayerDescription.copiedMessage)),
            noAccount.map(to: MessageViewModelImpl.error(description: Strings.PlayerDescription.noEmailAcc))
        ).map{ $0 as MessageViewModel }

        let playerStatus = playersService.isFavourite(player: id).success()
        let isPlayerFavorite = optionsTrigger.asDriver(onErrorJustReturn: ()).flatMapLatest{ playerStatus }
        shoudShowAlert = isPlayerFavorite.map{ isPlayerFavorite in
            let addRemove = isPlayerFavorite
                ? AlertActionViewModelImpl(title: Strings.PlayerDescription.removeFromFavorites, action: removeFromFavorites)
                : AlertActionViewModelImpl(title: Strings.PlayerDescription.addToFavorites, action: addToFavorites)
            let actions = [
                AlertActionViewModelImpl(title: Strings.PlayerDescription.copyCfg, action: copyCFG),
                AlertActionViewModelImpl(title: Strings.PlayerDescription.shareCfg, action: shareCFG),
                addRemove,
                AlertActionViewModelImpl(title: Strings.PlayerDescription.cancel, style: .destructive)
            ]
            return AlertViewModelImpl(
                title: Strings.PlayerDescription.options,
                style: .actionSheet,
                actions: actions
            )
        }
    }
}
