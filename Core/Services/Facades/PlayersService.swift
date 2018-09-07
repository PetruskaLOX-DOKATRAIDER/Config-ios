//
//  PlayersService.swift
//  Core
//
//  Created by Oleg Petrychuk on 11.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public enum PlayersServiceError: Error {
    case playerIsNotFavorite
    case playerIsFavorite
    case serverError(Error)
    case notFound
    case unknown
}

public protocol PlayersService {
    func getPreview(page: Int) -> DriverResult<Page<PlayerPreview>, PlayersServiceError>
    func getDescription(player id: Int) -> DriverResult<PlayerDescription, PlayersServiceError>
    func getFavoritePreview() -> DriverResult<[PlayerPreview], PlayersServiceError>
    func add(favourite id: Int) -> DriverResult<Void, PlayersServiceError>
    func remove(favourite id: Int) -> DriverResult<Void, PlayersServiceError>
    func isFavourite(player id: Int) -> DriverResult<Bool, PlayersServiceError>
}

public final class PlayersServiceImpl: PlayersService, ReactiveCompatible {
    private let reachabilityService: ReachabilityService
    private let playersAPIService: PlayersAPIService
    private let playersStorage: PlayersStorage
    
    public init(
        reachabilityService: ReachabilityService,
        playersAPIService: PlayersAPIService,
        playersStorage: PlayersStorage
    ) {
        self.reachabilityService = reachabilityService
        self.playersAPIService = playersAPIService
        self.playersStorage = playersStorage
    }
    
    public func getPreview(page: Int) -> DriverResult<Page<PlayerPreview>, PlayersServiceError> {
        guard reachabilityService.connection != .none else { return getStoredPreview() }
        let request = getRemotePreview(page: page)
        return .merge(request.filter{ $0.value == nil }, updatePreview(request.success()))
    }
    
    public func getDescription(player id: Int) -> DriverResult<PlayerDescription, PlayersServiceError> {
        guard reachabilityService.connection != .none else { return getStoredDescription(player: id) }
        let request = getRemoteDescription(player: id)
        return .merge(request.filter{ $0.value == nil }, updateDescription(request.success()))
    }

    public func getFavoritePreview() -> DriverResult<[PlayerPreview], PlayersServiceError> {
        return playersStorage.getFavoritePreview().map{ Result(value: $0) }
    }
    
    public func add(favourite id: Int) -> DriverResult<Void, PlayersServiceError> {
        let alreadyInFavorites = playersStorage.isFavourite(player: id).filter{ $0 }
        let success = playersStorage.add(favourite: id)
        return .merge(
            alreadyInFavorites.map(to: Result(error: .playerIsFavorite) ),
            success.map{ Result(value: ()) }
        )
    }
    
    public func remove(favourite id: Int) -> DriverResult<Void, PlayersServiceError> {
        let isNotInFavorites = playersStorage.isFavourite(player: id).filter{ !$0 }
        let success = playersStorage.remove(favourite: id)
        return .merge(
            isNotInFavorites.map(to: Result(error: .playerIsNotFavorite) ),
            success.map{ Result(value: ()) }
        )
    }
    
    public func isFavourite(player id: Int) -> DriverResult<Bool, PlayersServiceError> {
        return playersStorage.isFavourite(player: id).map{ Result(value: $0) }
    }
    
    private func getRemotePreview(page: Int) -> DriverResult<Page<PlayerPreview>, PlayersServiceError> {
        let request = playersAPIService.getPreview(page: page)
        let successData = request.success().filter{ $0.content.isNotEmpty }
        return .merge(
            successData.map{ Result(value: $0) },
            request.failure().map{ Result(error: .serverError($0.localizedDescription)) }
        )
    }
    
    private func updatePreview(_ remote: Driver<Page<PlayerPreview>>) -> DriverResult<Page<PlayerPreview>, PlayersServiceError> {
        return remote.flatMapLatest{ [weak self] page -> Driver<Page<PlayerPreview>> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.playersStorage.updatePreview(withNew: page.content).map(to: page)
        }.map{ Result(value: $0) }
    }
    
    private func getStoredPreview() -> DriverResult<Page<PlayerPreview>, PlayersServiceError> {
        let data = playersStorage.getPreview()
        return data.map{ Result(value: Page.new(content: $0, index: 1, totalPages: 1)) }
    }
    
    private func getRemoteDescription(player id: Int) -> DriverResult<PlayerDescription, PlayersServiceError> {
        let request = playersAPIService.getDescription(player: id)
        return .merge(
            request.success().map{ Result(value: $0) },
            request.failure().map{ Result(error: .serverError($0.localizedDescription)) }
        )
    }
    
    private func updateDescription(_ remote: Driver<PlayerDescription>) -> DriverResult<PlayerDescription, PlayersServiceError> {
        return remote.flatMapLatest { [weak self] player -> Driver<PlayerDescription> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.playersStorage.updateDescription(withNew: player).map(to: player)
        }.map{ Result(value: $0) }
    }
    
    private func getStoredDescription(player id: Int) -> DriverResult<PlayerDescription, PlayersServiceError> {
        let data = playersStorage.getDescription(player: id)
        let success = data.filterNil()
        let failure = data.filter{ $0 == nil }
        return .merge(
            success.map{ Result(value: $0) },
            failure.map(to: Result(error: .notFound))
        )
    }
}

extension PlayersServiceError: Equatable {
    public static func == (lhs: PlayersServiceError, rhs: PlayersServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.playerIsNotFavorite, .playerIsNotFavorite): return true
        case (.playerIsFavorite, .playerIsFavorite): return true
        case (.serverError, .serverError): return true
        case (.unknown, .unknown): return true
        default: return false
        }
    }
}
