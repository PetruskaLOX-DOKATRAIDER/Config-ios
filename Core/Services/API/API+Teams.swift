//
//  API+Teams.swift
//  Core
//
//  Created by Oleg Petrychuk on 16.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TRON

public protocol TeamsAPIService: AutoMockable {
    func getTeams(forPage page: Int) -> Response<Page<Team>, RequestError>
}

extension API {
    open class TeamsAPIServiceImpl: API, TeamsAPIService {
        public func getTeams(forPage page: Int) -> Response<Page<Team>, RequestError> {
            let request: Request<Page<Team>, RequestError> = tron.swiftyJSON.request("teamsData/teamsData\(page).json")
            request.urlBuilder = URLBuilder(baseURL: appEnvironment.apiURL)
            request.method = .get
            return request.asResult()
        }
    }
}
