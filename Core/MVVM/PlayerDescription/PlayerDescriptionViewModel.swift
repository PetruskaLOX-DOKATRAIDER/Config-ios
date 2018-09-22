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
    var alertViewModel: Driver<AlertViewModel> { get }
    var shouldShare: Driver<ShareItem> { get }
    var shouldClose: Driver<Void> { get }
    var shouldOpenURL: Driver<URL> { get }
    var optionsTrigger: PublishSubject<Void> { get }
    var detailsTrigger: PublishSubject<Void> { get }
    var sendCFGTrigger: PublishSubject<Void> { get }
    var refreshTrigger: PublishSubject<Void> { get }
    var closeTrigger: PublishSubject<Void> { get }
}

public final class PlayerDescriptionViewModelImpl: PlayerDescriptionViewModel, ReactiveCompatible {
    public let playerInfoViewModel: PlayerInfoViewModel
    public let messageViewModel: Driver<MessageViewModel>
    public let isWorking: Driver<Bool>
    public let alertViewModel: Driver<AlertViewModel>
    public let shouldShare: Driver<ShareItem>
    public let shouldClose: Driver<Void>
    public let shouldOpenURL: Driver<URL>
    public let optionsTrigger = PublishSubject<Void>()
    public let detailsTrigger = PublishSubject<Void>()
    public let sendCFGTrigger = PublishSubject<Void>()
    public let refreshTrigger = PublishSubject<Void>()
    public let closeTrigger = PublishSubject<Void>()

    public init(
        player id: Int,
        playersService: PlayersService,
        pasteboardService: PasteboardService,
        userStorage: UserStorage,
        emailService: EmailService
    ) {
        let request = refreshTrigger.asDriver(onErrorJustReturn: ()).flatMapLatest{ playersService.getDescription(player: id) }
        let error = request.failure()
        let player = request.success()
        playerInfoViewModel = PlayerInfoViewModelImpl(player: player)
        shouldClose = closeTrigger.asDriver(onErrorJustReturn: ())
        isWorking = Driver.merge(
            refreshTrigger.asDriver(onErrorJustReturn: ()).map(to: true),
            player.map(to: false),
            error.map(to: false)
        ).startWith(false)
        shouldOpenURL = detailsTrigger.asDriver(onErrorJustReturn: ()).withLatestFrom(player).map{ $0.moreInfoURL }.filterNil()
        
        let copyCFG = PublishSubject<Void>()
        let shareCFG = PublishSubject<Void>()
        let cfg = player.map{ $0.configURL }.filterNil()
        let copiedCFG = copyCFG.withLatestFrom(cfg).map{ pasteboardService.save(string: $0.absoluteString) }.asDriver(onErrorJustReturn: ())
        shouldShare = shareCFG.asDriver(onErrorJustReturn: ()).withLatestFrom(cfg).map{ ShareItem(url: $0) }
    
        let addToFavorites = PublishSubject<Void>()
        let removeFromFavorites = PublishSubject<Void>()
        let addedSuccess = addToFavorites.asDriver(onErrorJustReturn: ()).flatMapLatest{ playersService.add(favourite: id).success() }
        let removedSuccess = removeFromFavorites.asDriver(onErrorJustReturn: ()).flatMapLatest{ playersService.remove(favourite: id).success() }
        
        let sendCFG = sendCFGTrigger.asDriver(onErrorJustReturn: ()).withLatestFrom(cfg).flatMapLatest {
            emailService.send(withInfo: EmailInfo(recipient: userStorage.email.value ?? "", subject: Strings.PlayerDescription.sendCfg, message: $0.absoluteString)
        )}
        let noAccount = sendCFG.failure().filter{ $0 == .noAccount }
        
        messageViewModel = Driver.merge(
            error.map(to: MessageViewModelImpl.error()),
            addedSuccess.map(to: MessageViewModelImpl(title: Strings.PlayerDescription.options, description: Strings.PlayerDescription.addedFavoriteMessage)),
            removedSuccess.map(to: MessageViewModelImpl(title: Strings.PlayerDescription.options, description: Strings.PlayerDescription.removedFavoriteMessage)),
            copiedCFG.map(to: MessageViewModelImpl(title: Strings.PlayerDescription.options, description: Strings.PlayerDescription.copiedMessage)),
            noAccount.map(to: MessageViewModelImpl.error(description: Strings.PlayerDescription.noEmailAcc))
        ).map{ $0 as MessageViewModel }

        let isPlayerFavorite = optionsTrigger.asDriver(onErrorJustReturn: ()).flatMapLatest{ playersService.isFavourite(player: id).success() }
        alertViewModel = isPlayerFavorite.map{ isPlayerFavorite in
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
