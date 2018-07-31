//
//  API+News.swift
//  Core
//
//  Created by Oleg Petrychuk on 31.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import TRON

public protocol NewsAPIService: AutoMockable {
    func getNewsPreview(forPage page: Int) -> Response<Page<NewsPreview>, RequestError>
    func getNewsDescription(byID id: Int) -> Response<NewsDescription, RequestError>
}

extension API {
    open class NewsAPIServiceImpl: API, NewsAPIService {
        public func getNewsPreview(forPage page: Int) -> Response<Page<NewsPreview>, RequestError> {
            let request: Request<Page<NewsPreview>, RequestError> = tron.swiftyJSON.request("newsPreviewData/newsPreviewData\(page).json")
            request.urlBuilder = URLBuilder(baseURL: appEnvironment.apiURL)
            request.method = .get
            return request.asResult()
        }
        
        public func getNewsDescription(byID id: Int) -> Response<NewsDescription, RequestError> {
            let request: Request<NewsDescription, RequestError> = tron.swiftyJSON.request("newsDescriptionData/newsID\(id).json")
            request.urlBuilder = URLBuilder(baseURL: appEnvironment.apiURL)
            request.method = .get
            return request.asResult()
        }
    }
}
