//
//  API+Players.swift
//  Core
//
//  Created by Oleg Petrychuk on 22.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TRON

public protocol PlayersAPIService: AutoMockable {
    func getPlayers(forPage page: Int) -> Response<Page<PlayerPreview>, RequestError>
}

extension API {
    open class PlayersAPIServiceImpl: API, PlayersAPIService {
        public func getPlayers(forPage page: Int) -> Response<Page<PlayerPreview>, RequestError> {
            let request: Request<Page<PlayerPreview>, String> = tron.swiftyJSON.request("playersData/" + "playersData\(page).json")
            request.urlBuilder = URLBuilder(baseURL: appEnvironment.apiURL)
            request.method = .get
            return request.asResult()
        }
    }
}
