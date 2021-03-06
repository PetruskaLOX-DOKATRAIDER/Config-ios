//
//  PlayersBannerViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 16.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol PlayersBannerViewModel: AutoMockable {
    var playersPaginator: Paginator<PlayerBannerItemViewModel> { get }
    var currentPage: Driver<Int> { get }
    var pageTrigger: PublishSubject<Int> { get }
    var errorMessage: Driver<String> { get }
    var shouldRouteDescription: Driver<Int> { get }
}

public final class PlayersBannerViewModelImpl: PlayersBannerViewModel, ReactiveCompatible {
    public let playersPaginator: Paginator<PlayerBannerItemViewModel>
    public let currentPage: Driver<Int>
    public let pageTrigger = PublishSubject<Int>()
    public let errorMessage: Driver<String>
    public let shouldRouteDescription: Driver<Int>
    
    public init(bannerService: BannerService) {
        let route = PublishSubject<Int>()
        shouldRouteDescription = route.asDriver(onErrorJustReturn: 0)
        func remapToViewModels(page: Page<PlayerBanner>) -> Page<PlayerBannerItemViewModel> {
            return Page.new(
                content: page.content.map{ player in
                    let vm = PlayerBannerItemViewModelImpl(playerBanner: player)
                    vm.selectionTrigger.asDriver(onErrorJustReturn: ()).map{ player.id }.drive(route).disposed(by: vm.rx.disposeBag)
                    return vm
                },
                index: page.index,
                totalPages: page.totalPages
            )
        }
        
        playersPaginator = Paginator(factory:{ bannerService.getForPlayers(page: $0).asObservable().map{ try $0.dematerialize() }.map(remapToViewModels) })
        currentPage = pageTrigger.startWith(0).asDriver(onErrorJustReturn: 0)
        errorMessage = playersPaginator.error.toVoid().map{ Strings.Errors.generalMessage }.startWith("")
    }
}
