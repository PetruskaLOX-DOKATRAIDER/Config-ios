//
//  API+Events.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TRON

public protocol EventsAPIService: AutoMockable {
    func getEvents(forPage page: Int) -> Response<Page<Event>, RequestError>
}

extension API {
    open class EventsAPIServiceImpl: API, EventsAPIService {
        public func getEvents(forPage page: Int) -> Response<Page<Event>, RequestError> {
            let request: Request<Page<Event>, RequestError> = tron.swiftyJSON.request("teamsData/teamsData\(page).json")
            request.urlBuilder = URLBuilder(baseURL: appEnvironment.apiURL)
            request.method = .get
            return request.asResult()
        }
    }
}
