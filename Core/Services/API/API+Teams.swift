//
//  API+Teams.swift
//  Core
//
//  Created by Oleg Petrychuk on 16.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol TeamsAPIService: AutoMockable {
    func get(page: Int) -> Response<Page<Team>, RequestError>
}

extension API {
    public final class TeamsAPIServiceImpl: API, TeamsAPIService {
        public func get(page: Int) -> Response<Page<Team>, RequestError> {
            let request: Request<Page<Team>, RequestError> = tron.swiftyJSON.request("teamsData/teamsData\(page).json")
            request.urlBuilder = URLBuilder(baseURL: appEnvironment.apiURL.absoluteString)
            request.method = .get
            return request.asResult()
        }
    }
}
