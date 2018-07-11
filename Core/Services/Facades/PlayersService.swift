//
//  PlayersService.swift
//  Core
//
//  Created by Oleg Petrychuk on 11.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol PlayersService: AutoMockable {
    func getPlayers(forPage page: Int) -> Response<Page<PlayerPreview>, String>
}

public final class PlayersServiceImpl: PlayersService, ReactiveCompatible {
    private let reachabilityService: ReachabilityService
    private let playersAPIService: PlayersAPIService
    private let playersStorage: PlayersStorage
    
    public init(reachabilityService: ReachabilityService, playersAPIService: PlayersAPIService, playersStorage: PlayersStorage) {
        self.reachabilityService = reachabilityService
        self.playersAPIService = playersAPIService
        self.playersStorage = playersStorage
    }
    
    public func getPlayers(forPage page: Int) -> Response<Page<PlayerPreview>, String> {
        if reachabilityService.connection != .none {
            let request = playersAPIService.getPlayers(forPage: page)
            request.success().map{ $0.content }.drive(onNext: { [weak self] players in
                try? self?.playersStorage.update(withNewPlayers: players)
            }).disposed(by: rx.disposeBag)
            return request
        }
        
        let storedData = (try? playersStorage.fetchPlayersPreview()) ?? []
        return .just(Result(value: Page.new(content: storedData, index: 0, totalPages: 0)))
    }
}
