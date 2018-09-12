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
    var shouldRouteDescription: Driver<Int> { get }
}

public final class PlayersViewModelImpl: PlayersViewModel, ReactiveCompatible {
    public let playersPaginator: Paginator<PlayerPreviewViewModel>
    public let messageViewModel: Driver<MessageViewModel>
    public let profileTrigger = PublishSubject<Void>()
    public let shouldRouteProfile: Driver<Void>
    public let shouldRouteDescription: Driver<Int>
    
    public init(playersService: PlayersService) {
        let route = PublishSubject<Int>()
        shouldRouteDescription = route.asDriver(onErrorJustReturn: 0)
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
        
        playersPaginator = Paginator(factory:{ playersService.getPreview(page: $0).asObservable().map{ try $0.dematerialize() }.map(remapToViewModels) })
        messageViewModel = playersPaginator.error.map{ MessageViewModelImpl.error(description: $0.localizedDescription) }
        shouldRouteProfile = profileTrigger.asDriver(onErrorJustReturn: ())
    }
}
