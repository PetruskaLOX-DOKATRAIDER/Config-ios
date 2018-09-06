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
    var profileTrigger: PublishSubject<Void> { get }
    var shouldRouteProfile: Driver<Void> { get }
    var shouldRoutePlayerDescription: Driver<Int> { get }
}

final class PlayersViewModelImpl: PlayersViewModel, ReactiveCompatible {
    let playersPaginator: Paginator<PlayerPreviewViewModel>
    let messageViewModel: Driver<MessageViewModel>
    let profileTrigger = PublishSubject<Void>()
    let shouldRouteProfile: Driver<Void>
    let shouldRoutePlayerDescription: Driver<Int>
    
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
        
        playersPaginator = Paginator(factory:{ playersService.getPlayerPreview(forPage: $0).success().map(remapToViewModels).asObservable() })
        messageViewModel = playersPaginator.error.map{ MessageViewModelImpl.error(description: $0.localizedDescription) }
        shouldRouteProfile = profileTrigger.asDriver(onErrorJustReturn: ())
    }
}
