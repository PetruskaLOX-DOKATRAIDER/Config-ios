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
    var shouldRoutePlayerDescription: Driver<Int> { get }
}

final class TeamsViewModelImpl: TeamsViewModel, ReactiveCompatible {
    let playersBannerViewModel: PlayersBannerViewModel
    let teamsPaginator: Paginator<TeamItemViewModel>
    let messageViewModel: Driver<MessageViewModel>
    let profileTrigger = PublishSubject<Void>()
    let shouldRouteProfile: Driver<Void>
    let shouldRoutePlayerDescription: Driver<Int>
    
    init(
        teamsService: TeamsService,
        playersBannerViewModel: PlayersBannerViewModel
    ) {
        let route = PublishSubject<Int>()
        shouldRoutePlayerDescription = route.asDriver(onErrorJustReturn: 0)
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
        
        teamsPaginator = Paginator(factory:{ teamsService.get(page: $0).success().map( remapToViewModels ).asObservable() })
        shouldRouteProfile = profileTrigger.asDriver(onErrorJustReturn: ())
        messageViewModel = teamsPaginator.error.map{ MessageViewModelImpl.error(description: $0.localizedDescription) }
        self.playersBannerViewModel = playersBannerViewModel
    }
}
