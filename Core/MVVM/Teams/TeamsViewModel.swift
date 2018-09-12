//
//  TeamsViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol TeamsViewModel {
    var playersBannerViewModel: PlayersBannerViewModel { get }
    var teamsPaginator: Paginator<TeamItemViewModel> { get }
    var messageViewModel: Driver<MessageViewModel> { get }
    var profileTrigger: PublishSubject<Void> { get }
    var shouldRouteProfile: Driver<Void> { get }
    var shouldRouteDescription: Driver<Int> { get }
}

public final class TeamsViewModelImpl: TeamsViewModel, ReactiveCompatible {
    public let playersBannerViewModel: PlayersBannerViewModel
    public let teamsPaginator: Paginator<TeamItemViewModel>
    public let messageViewModel: Driver<MessageViewModel>
    public let profileTrigger = PublishSubject<Void>()
    public let shouldRouteProfile: Driver<Void>
    public let shouldRouteDescription: Driver<Int>
    
    public init(
        teamsService: TeamsService,
        playersBannerViewModel: PlayersBannerViewModel
    ) {
        let route = PublishSubject<Int>()
        shouldRouteDescription = route.asDriver(onErrorJustReturn: 0)
        func remapToViewModels(page: Page<Team>) -> Page<TeamItemViewModel> {
            return Page.new(
                content: page.content.map{ team in
                    let teamVM = TeamItemViewModelImpl(team: team)
                    for (index, playerVM) in teamVM.players.enumerated() {
                        let selectedPlayer = playerVM.selectionTrigger.asDriver(onErrorJustReturn: ()).map{ team.players[safe: index] }
                        selectedPlayer.filterNil().map{ $0.id }.drive(route).disposed(by: teamVM.rx.disposeBag)
                    }
                    return teamVM
                },
                index: page.index,
                totalPages: page.totalPages
            )
        }
        
        teamsPaginator = Paginator(factory:{ teamsService.get(page: $0).asObservable().map{ try $0.dematerialize() }.map(remapToViewModels) })
        shouldRouteProfile = profileTrigger.asDriver(onErrorJustReturn: ())
        messageViewModel = teamsPaginator.error.map{ MessageViewModelImpl.error(description: $0.localizedDescription) }
        self.playersBannerViewModel = playersBannerViewModel
    }
}
