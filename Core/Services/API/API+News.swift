//
//  API+News.swift
//  Core
//
//  Created by Oleg Petrychuk on 31.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol NewsAPIService: AutoMockable {
    func get(page: Int) -> Response<Page<NewsPreview>, RequestError>
    func get(news id: Int) -> Response<NewsDescription, RequestError>
}

extension API {
    public final class NewsAPIServiceImpl: API, NewsAPIService {
        public func get(page: Int) -> Response<Page<NewsPreview>, RequestError> {
            let request: Request<Page<NewsPreview>, RequestError> = tron.swiftyJSON.request("newsPreviewData/newsPreviewData\(page).json")
            request.urlBuilder = URLBuilder(baseURL: appEnvironment.apiURL.absoluteString)
            request.method = .get
            return request.asResult()
        }
        
        public func get(news id: Int) -> Response<NewsDescription, RequestError> {
            let request: Request<NewsDescription, RequestError> = tron.swiftyJSON.request("newsDescriptionData/newsID\(id).json")
            request.urlBuilder = URLBuilder(baseURL: appEnvironment.apiURL.absoluteString)
            request.method = .get
            return request.asResult()
        }
    }
}
