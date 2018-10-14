//
//  TeamsService.swift
//  Core
//
//  Created by Oleg Petrychuk on 16.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public enum TeamsServiceError: Error {
    case serverError(Error)
    case unknown
}

public protocol TeamsService: AutoMockable {
    func get(page: Int) -> DriverResult<Page<Team>, TeamsServiceError>
}

public final class TeamsServiceImpl: TeamsService, ReactiveCompatible {
    private let reachabilityService: ReachabilityService
    private let teamsAPIService: TeamsAPIService
    private let teamsStorage: TeamsStorage
    
    public init(
        reachabilityService: ReachabilityService,
        teamsAPIService: TeamsAPIService,
        teamsStorage: TeamsStorage
    ) {
        self.reachabilityService = reachabilityService
        self.teamsAPIService = teamsAPIService
        self.teamsStorage = teamsStorage
    }

    public func get(page: Int) -> DriverResult<Page<Team>, TeamsServiceError> {
        guard reachabilityService.connection != .none else { return getStored() }
        let request = getRemote(page: page)
        return .merge(request.filter{ $0.value == nil }, update(request.success()))
    }
    
    private func getRemote(page: Int) -> DriverResult<Page<Team>, TeamsServiceError> {
        let request = teamsAPIService.get(page: page)
        let successData = request.success().filter{ $0.content.isNotEmpty }
        return .merge(
            successData.map{ Result(value: $0) },
            request.failure().map{ Result(error: .serverError($0.localizedDescription)) }
        )
    }
    
    private func update(_ remote: Driver<Page<Team>>) -> DriverResult<Page<Team>, TeamsServiceError> {
        return remote.flatMapLatest{ [weak self] page -> Driver<Page<Team>> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.teamsStorage.update(withNew: page.content).map(to: page)}.map{ Result(value: $0)
        }
    }
    
    private func getStored() -> DriverResult<Page<Team>, TeamsServiceError> {
         return teamsStorage.get().map{ Result(value: Page.new(content: $0, index: 1, totalPages: 1)) }
    }
}
