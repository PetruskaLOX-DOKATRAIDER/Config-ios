//
//  TeamsService.swift
//  Core
//
//  Created by Oleg Petrychuk on 16.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol TeamsService: AutoMockable {
    func getTeams(forPage page: Int) -> Response<Page<Team>, RequestError>
}

public final class TeamsServiceImpl: TeamsService, ReactiveCompatible {
    private let dataLoaderHelper: PageDataLoaderHelper<Team>

    public init(
        reachabilityService: ReachabilityService,
        teamsAPISerivce: TeamsAPIService,
        teamsStorage: TeamsStorage
    ) {
        dataLoaderHelper = PageDataLoaderHelper(
            reachabilityService: reachabilityService,
            apiSource: { teamsAPISerivce.getTeams(forPage: $0) },
            storageSource: { try? teamsStorage.fetchTeams() },
            updateStorage: { try? teamsStorage.update(withNewTeams: $0) }
        )
    }

    public func getTeams(forPage page: Int) -> Response<Page<Team>, RequestError> {
        return dataLoaderHelper.loadData(forPage: page)
    }
}
