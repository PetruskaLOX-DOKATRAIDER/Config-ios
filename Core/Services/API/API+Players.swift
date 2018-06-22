//
//  API+Players.swift
//  Core
//
//  Created by Oleg Petrychuk on 22.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TRON

// MARK: Protocol

public protocol PlayersAPIService: AutoMockable {
    func getPlayers(forPage page: Int) -> Response<Page<PlayerPreview>, String>
}

// MARK: Implementation

extension API: PlayersAPIService {
    public func getPlayers(forPage page: Int) -> Response<Page<PlayerPreview>, String> {
        let request: Request<Page<PlayerPreview>, String> = tron.swiftyJSON.request("playersData/" + "playersData\(page)")
        request.urlBuilder = URLBuilder(baseURL: appEnvironment.apiURL)
        request.method = .get
        request.authorizationRequirement = .required
        return request.asResult()
    }
}

// MARK: Factory

public class PlayersAPIServiceFactory {
    public static func `default`(
        api: API = APIFactory.default()
    ) -> PlayersAPIService {
        return api
    }
}
