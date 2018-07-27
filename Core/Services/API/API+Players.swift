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
    func getBannerPlayers(forPage page: Int) -> Response<Page<PlayerBanner>, RequestError>
    func getPlayerDescription(byPlayerID playerID: PlayerID) -> Response<PlayerDescription, RequestError>
}

extension API {
    open class PlayersAPIServiceImpl: API, PlayersAPIService {
        public func getPlayers(forPage page: Int) -> Response<Page<PlayerPreview>, RequestError> {
            let request: Request<Page<PlayerPreview>, RequestError> = tron.swiftyJSON.request("playersData/playersData\(page).json")
            request.urlBuilder = URLBuilder(baseURL: appEnvironment.apiURL)
            request.method = .get
            return request.asResult()
        }
        
        public func getBannerPlayers(forPage page: Int) -> Response<Page<PlayerBanner>, RequestError> {
            let request: Request<Page<PlayerBanner>, RequestError> = tron.swiftyJSON.request("bannersData/bannersData\(page).json")
            request.urlBuilder = URLBuilder(baseURL: appEnvironment.apiURL)
            request.method = .get
            return request.asResult()
        }
        
        public func getPlayerDescription(byPlayerID playerID: PlayerID) -> Response<PlayerDescription, RequestError> {
            let request: Request<PlayerDescription, RequestError> = tron.swiftyJSON.request("bannersData/bannersData\(playerID).json")
            request.urlBuilder = URLBuilder(baseURL: appEnvironment.apiURL)
            request.method = .get
            return request.asResult()
        }
    }
}
