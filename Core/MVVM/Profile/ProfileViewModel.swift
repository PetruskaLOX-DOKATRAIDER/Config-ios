//
//  ProfileViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol ProfileViewModel {
    var sections: Driver<[SectionViewModelType]> { get }
    var shouldRouteFavoritePlayers: Driver<Void> { get }
    var shouldRouteSkins: Driver<Void> { get }
    var shouldOpenURL: Driver<URL> { get }
    var shouldSendFeedback: Driver<Void> { get }
    //var shouldShare: Driver<Void> { get }
}

public final class ProfileViewModelImpl: ProfileViewModel {
    public let sections: Driver<[SectionViewModelType]>
    public let shouldRouteFavoritePlayers: Driver<Void>
    public let shouldRouteSkins: Driver<Void>
    public let shouldOpenURL: Driver<URL>
    public let shouldSendFeedback: Driver<Void>
    //public let shouldShare: Driver<Void>
    
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
        let storageVM = StorageSetupViewModelImpl(imageLoaderService: imageLoaderService)
        sections = .just([
            SectionViewModel(topic: SectionTopicViewModelImpl(title: Strings.Profile.personalSection), items: [favoritePlayersVM, skinsVM]),
            SectionViewModel(topic: SectionTopicViewModelImpl(title: Strings.Profile.appSection), items: [sendFeedbackVM, donateVM, rateAppVM, shareVM, emailVM]),
            SectionViewModel(topic: SectionTopicViewModelImpl(title: Strings.Profile.storageSection), items: [storageVM])
        ])

        shouldRouteFavoritePlayers = favoritePlayersVM.selectionTrigger.asDriver(onErrorJustReturn: ())
        shouldRouteSkins = skinsVM.selectionTrigger.asDriver(onErrorJustReturn: ())
        shouldSendFeedback = sendFeedbackVM.selectionTrigger.asDriver(onErrorJustReturn: ())
        shouldOpenURL = .merge(
            donateVM.selectionTrigger.asDriver(onErrorJustReturn: ()).map(to: appEnvironment.appStoreURL),
            rateAppVM.selectionTrigger.asDriver(onErrorJustReturn: ()).map(to: appEnvironment.appStoreURL)
        )
    }
}
