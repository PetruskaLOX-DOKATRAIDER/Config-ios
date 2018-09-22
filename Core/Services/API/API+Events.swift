//
//  API+Events.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol EventsAPIService: AutoMockable {
    func get(page: Int) -> Response<Page<Core.Event>, RequestError>
}

extension API {
    public final class EventsAPIServiceImpl: API, EventsAPIService {
        public func get(page: Int) -> Response<Page<Event>, RequestError> {
            let request: Request<Page<Event>, RequestError> = tron.swiftyJSON.request("eventsData\(page).json")
            request.urlBuilder = URLBuilder(baseURL: appEnvironment.apiURL.absoluteString)
            request.method = .get
            return request.asResult()
        }
    }
}
