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
    var shouldRoutePlayerDescription: Driver<Int> { get }
}

public final class FavoritePlayersViewModelImpl: FavoritePlayersViewModel {
    public let players: Driver<[PlayerPreviewViewModel]>
    public let isContentExist: Driver<Bool>
    public let refreshTrigger = PublishSubject<Void>()
    public let closeTrigger = PublishSubject<Void>()
    public let shouldClose: Driver<Void>
    public let shouldRoutePlayerDescription: Driver<Int>
    
    public init(playersService: PlayersService) {
        let route = PublishSubject<Int>()
        shouldRoutePlayerDescription = route.asDriver(onErrorJustReturn: 0)
        func remapToViewModels(player: PlayerPreview) -> PlayerPreviewViewModel {
            let vm = PlayerPreviewViewModelImpl(player: player)
            vm.selectionTrigger.asDriver(onErrorJustReturn: ()).map{ player.id }.drive(route).disposed(by: vm.rx.disposeBag)
            return vm
        }
        let request = playersService.getFavoritePreview()
        let players = request.success().map{ $0.map{ remapToViewModels(player: $0) } }
        self.players = refreshTrigger.asDriver(onErrorJustReturn: ()).flatMapLatest{ players }
        isContentExist = request.success().map{ $0.isNotEmpty }.startWith(true)
        shouldClose = closeTrigger.asDriver(onErrorJustReturn: ())
    }
}
