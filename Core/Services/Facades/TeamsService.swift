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

public protocol TeamsService {
    func getTeams(forPage page: Int) -> DriverResult<Page<Team>, TeamsServiceError>
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

    public func getTeams(forPage page: Int) -> DriverResult<Page<Team>, TeamsServiceError> {
        guard reachabilityService.connection != .none else { return getStoredTeams() }
        let request = getRemoteEvents(forPage: page)
        return .merge(request.filter{ $0.value == nil }, updateTeams(request.success()))
    }
    
    private func getRemoteEvents(forPage page: Int) -> DriverResult<Page<Team>, TeamsServiceError> {
        let request = teamsAPIService.getTeams(forPage: page)
        let successData = request.success().filter{ $0.content.isNotEmpty }
        return .merge(
            successData.map{ Result(value: $0) },
            request.failure().map{ Result(error: .serverError($0.localizedDescription)) }
        )
    }
    
    private func updateTeams(_ remoteTeams: Driver<Page<Team>>) -> DriverResult<Page<Team>, TeamsServiceError> {
        return remoteTeams.flatMapLatest{ [weak self] page -> Driver<Page<Team>> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.teamsStorage.update(withNewTeams: page.content).map(to: page)}.map{ Result(value: $0)
        }
    }
    
    private func getStoredTeams() -> DriverResult<Page<Team>, TeamsServiceError> {
         return teamsStorage.fetchTeams().map{ Result(value: Page.new(content: $0, index: 1, totalPages: 1)) }
    }
}
