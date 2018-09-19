//
//  FavoritePlayersViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 02.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol FavoritePlayersViewModel {
    var players: Driver<[PlayerPreviewViewModel]> { get }
    var isContentExist: Driver<Bool> { get }
    var refreshTrigger: PublishSubject<Void> { get }
    var closeTrigger: PublishSubject<Void> { get }
    var shouldClose: Driver<Void> { get }
    var shouldRouteDescription: Driver<Int> { get }
}

public final class FavoritePlayersViewModelImpl: FavoritePlayersViewModel {
    public let players: Driver<[PlayerPreviewViewModel]>
    public let isContentExist: Driver<Bool>
    public let refreshTrigger = PublishSubject<Void>()
    public let closeTrigger = PublishSubject<Void>()
    public let shouldClose: Driver<Void>
    public let shouldRouteDescription: Driver<Int>
    
    public init(playersService: PlayersService) {
        let route = PublishSubject<Int>()
        shouldRouteDescription = route.asDriver(onErrorJustReturn: 0)
        func remapToViewModels(player: PlayerPreview) -> PlayerPreviewViewModel {
            let vm = PlayerPreviewViewModelImpl(player: player)
            vm.selectionTrigger.asDriver(onErrorJustReturn: ()).map{ player.id }.drive(route).disposed(by: vm.rx.disposeBag)
            return vm
        }
        let data = refreshTrigger.asDriver(onErrorJustReturn: ()).flatMapLatest{ playersService.getFavoritePreview() }
        players = data.success().map{ $0.map{ remapToViewModels(player: $0) } }
        isContentExist = players.map{ $0.isNotEmpty }.startWith(true)
        shouldClose = closeTrigger.asDriver(onErrorJustReturn: ())
    }
}
