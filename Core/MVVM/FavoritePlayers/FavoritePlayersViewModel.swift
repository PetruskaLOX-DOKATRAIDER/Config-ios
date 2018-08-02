//
//  FavoritePlayersViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 02.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol FavoritePlayersViewModel {
    //var playersPaginator: Paginator<PlayerPreviewViewModel> { get }
    var closeTrigger: PublishSubject<Void> { get }
    var shouldClose: Driver<Void> { get }
    var shouldRoutePlayerDescription: Driver<Int> { get }
}

public final class FavoritePlayersViewModelImpl: FavoritePlayersViewModel {
    //public let playersPaginator: Paginator<PlayerPreviewViewModel>
    public let closeTrigger = PublishSubject<Void>()
    public let shouldClose: Driver<Void>
    public let shouldRoutePlayerDescription: Driver<Int>
    
    public init(playersService: PlayersService) {
        let route = PublishSubject<Int>()
        shouldRoutePlayerDescription = route.asDriver(onErrorJustReturn: 0)
        func remapToViewModels(page: Page<PlayerPreview>) -> Page<PlayerPreviewViewModel> {
            return Page.new(
                content: page.content.map{ player in
                    let vm = PlayerPreviewViewModelImpl(player: player)
                    vm.selectionTrigger.asDriver(onErrorJustReturn: ()).map{ player.id }.drive(route).disposed(by: vm.rx.disposeBag)
                    return vm
                },
                index: page.index,
                totalPages: page.totalPages
            )
        }
        
        //playersPaginator = Paginator(factory: { playersService.getFavoritePlayersPreview(forPage: $0).map{ remapToViewModels(page: $0) }.asObservable() })
        shouldClose = closeTrigger.asDriver(onErrorJustReturn: ())
    }
}
