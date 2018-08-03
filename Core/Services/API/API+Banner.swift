//
//  API+Banner.swift
//  Core
//
//  Created by Oleg Petrychuk on 03.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TRON

public protocol BannerAPIService: AutoMockable {
    func getBannerForPlayers(forPage page: Int) -> Response<Page<PlayerBanner>, RequestError>
}

extension API {
    open class BannerAPIServiceImpl: API, BannerAPIService {
        public func getBannerForPlayers(forPage page: Int) -> Response<Page<PlayerBanner>, RequestError> {
            let request: Request<Page<PlayerBanner>, RequestError> = tron.swiftyJSON.request("bannersData/bannersData\(page).json")
            request.urlBuilder = URLBuilder(baseURL: appEnvironment.apiURL)
            request.method = .get
            return request.asResult()
        }
    }
}
