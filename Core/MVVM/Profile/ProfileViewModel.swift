//
//  ProfileViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol ProfileItemViewModel {}
extension StorageSetupViewModelImpl: ProfileItemViewModel {}
extension ProfileEmailItemViewModelImpl: ProfileItemViewModel {}
extension FavoritePlayersItemViewModelImpl: ProfileItemViewModel {}
extension ProfileDetailItemViewModelImpl: ProfileItemViewModel {}

public protocol ProfileViewModel {
    var items: Driver<[[ProfileItemViewModel]]> { get }
    var shouldRouteFavoritePlayers: Driver<Void> { get }
    var shouldRouteSkins: Driver<Void> { get }
    var shouldOpenURL: Driver<URL> { get }
    var shouldSendFeedback: Driver<Void> { get }
    //var shouldShare: Driver<Void> { get }
}

public final class ProfileViewModelImpl: ProfileViewModel {
    public let items: Driver<[[ProfileItemViewModel]]>
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
        let skinsVM = ProfileDetailItemViewModelImpl(title: Strings.Profile.skins, icon: Images.Profile.skins)
        let sendFeedbackVM = ProfileDetailItemViewModelImpl(title: Strings.Profile.feedback, icon: Images.Profile.feedback)
        let donateVM = ProfileDetailItemViewModelImpl(title: Strings.Profile.donate, icon: Images.Profile.donate)
        let rateAppVM = ProfileDetailItemViewModelImpl(title: Strings.Profile.rateApp, icon: Images.Profile.rate)
        let emailVM = ProfileEmailItemViewModelImpl(userStorage: userStorage)
        let shareVM = ProfileDetailItemViewModelImpl(title: Strings.Profile.share, icon: Images.General.share)
        let storageVM = StorageSetupViewModelImpl(imageLoaderService: imageLoaderService)
        
        items = .just([
            [favoritePlayersVM, skinsVM],
            [sendFeedbackVM, donateVM, rateAppVM, shareVM, emailVM],
            [storageVM]
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
