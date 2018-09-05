//
//  API+Players.swift
//  Core
//
//  Created by Oleg Petrychuk on 22.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol PlayersAPIService {
    func getPlayersPreview(forPage page: Int) -> Response<Page<PlayerPreview>, RequestError>
    func getPlayerDescription(byPlayerID playerID: Int) -> Response<PlayerDescription, RequestError>
}

extension API {
    public final class PlayersAPIServiceImpl: API, PlayersAPIService {
        public func getPlayersPreview(forPage page: Int) -> Response<Page<PlayerPreview>, RequestError> {
            let request: Request<Page<PlayerPreview>, RequestError> = tron.swiftyJSON.request("playersData/playersData\(page).json")
            request.urlBuilder = URLBuilder(baseURL: appEnvironment.apiURL.absoluteString)
            request.method = .get
            return request.asResult()
        }
        
        public func getPlayerDescription(byPlayerID playerID: Int) -> Response<PlayerDescription, RequestError> {
            let request: Request<PlayerDescription, RequestError> = tron.swiftyJSON.request("playerDescriptionData/playerID\(playerID).json")
            request.urlBuilder = URLBuilder(baseURL: appEnvironment.apiURL.absoluteString)
            request.method = .get
            return request.asResult()
        }
    }
}
