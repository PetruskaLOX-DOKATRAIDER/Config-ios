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
    var profileTrigger: BehaviorRelay<Void> { get }
    var shouldRouteProfile: Driver<Void> { get }
    var shouldRoutePlayerDescription: Driver<PlayerID> { get }
}

public final class TeamsViewModelImpl: TeamsViewModel, ReactiveCompatible {
    public let playersBannerViewModel: PlayersBannerViewModel
    public let teamsPaginator: Paginator<TeamItemViewModel>
    public let messageViewModel: Driver<MessageViewModel>
    public let profileTrigger = BehaviorRelay(value: ())
    public let shouldRouteProfile: Driver<Void>
    public let shouldRoutePlayerDescription: Driver<PlayerID>
    
    public init(teamsService: TeamsService, playersBannerViewModel: PlayersBannerViewModel) {
        let route = PublishSubject<PlayerID>()
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
        
        let message = PublishSubject<MessageViewModel>()
        messageViewModel = message.asDriver(onErrorJustReturn: MessageViewModelFactory.error())
        teamsPaginator = Paginator(factory: { teamsService.getTeams(forPage: $0).success().map(remapToViewModels).asObservable() })
        shouldRouteProfile = profileTrigger.asDriver()
        self.playersBannerViewModel = playersBannerViewModel
        teamsPaginator.error.map{ MessageViewModelFactory.error(description: $0.localizedDescription) }.drive(message).disposed(by: rx.disposeBag)
    }
}
