//
//  ProfileViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol ProfileViewModel {
    var sections: Driver<[SectionViewModelType]> { get }
    var messageViewModel: Driver<MessageViewModel> { get }
    var shouldRouteFavoritePlayers: Driver<Void> { get }
    var shouldRouteSkins: Driver<Void> { get }
    var shouldRouteTutorial: Driver<Void> { get }
    var shouldOpenURL: Driver<URL> { get }
    var shouldSendFeedback: Driver<Void> { get }
    var shouldShare: Driver<ShareItem> { get }
}

public final class ProfileViewModelImpl: ProfileViewModel {
    public let sections: Driver<[SectionViewModelType]>
    public let messageViewModel: Driver<MessageViewModel>
    public let shouldRouteFavoritePlayers: Driver<Void>
    public let shouldRouteSkins: Driver<Void>
    public let shouldRouteTutorial: Driver<Void>
    public let shouldOpenURL: Driver<URL>
    public let shouldSendFeedback: Driver<Void>
    public let shouldShare: Driver<ShareItem>
    
    init(
        appEnvironment: AppEnvironment,
        playersStorage: PlayersStorage,
        imageLoaderService: ImageLoaderService,
        userStorage: UserStorage
    ) {
        let favoritePlayersVM = FavoritePlayersItemViewModelImpl(playersStorage: playersStorage)
        let skinsVM = SectionItemViewModelImpl(title: Strings.Profile.skins, icon: Images.Profile.skins)
        let sendFeedbackVM = SectionItemViewModelImpl(title: Strings.Profile.feedback, icon: Images.Profile.feedback, withDetail: false)
        let donateVM = SectionItemViewModelImpl(title: Strings.Profile.donate, icon: Images.Profile.donate)
        let rateAppVM = SectionItemViewModelImpl(title: Strings.Profile.rateApp, icon: Images.Profile.rate)
        let emailVM = ProfileEmailItemViewModelImpl(userStorage: userStorage)
        let shareVM = SectionItemViewModelImpl(title: Strings.Profile.share, icon: Images.General.share, withDetail: false)
        let tutorialVM = SectionItemViewModelImpl(title: Strings.Profile.tutorial, icon: Images.Profile.rate, withDetail: true)
        let storageVM = StorageSetupViewModelImpl(imageLoaderService: imageLoaderService)
        sections = .just([
            SectionViewModel(items: [favoritePlayersVM, skinsVM]),
            SectionViewModel(items: [sendFeedbackVM, donateVM, rateAppVM, shareVM, emailVM, tutorialVM]),
            SectionViewModel(items: [storageVM])
        ])

        shouldShare = shareVM.selectionTrigger.asDriver(onErrorJustReturn: ()).map(to: ShareItem(url: appEnvironment.appStoreURL))
        shouldRouteFavoritePlayers = favoritePlayersVM.selectionTrigger.asDriver(onErrorJustReturn: ())
        shouldRouteSkins = skinsVM.selectionTrigger.asDriver(onErrorJustReturn: ())
        shouldRouteTutorial = tutorialVM.selectionTrigger.asDriver(onErrorJustReturn: ())
        shouldSendFeedback = sendFeedbackVM.selectionTrigger.asDriver(onErrorJustReturn: ())
        messageViewModel = storageVM.cacheСleared.asDriver(onErrorJustReturn: ()).map(to:
            MessageViewModelImpl(title: Strings.Storage.title, description: Strings.Storage.cleared)
        )
        shouldOpenURL = .merge(
            donateVM.selectionTrigger.asDriver(onErrorJustReturn: ()).map(to: appEnvironment.donateURL),
            rateAppVM.selectionTrigger.asDriver(onErrorJustReturn: ()).map(to: appEnvironment.appStoreURL)
        )
    }
}
