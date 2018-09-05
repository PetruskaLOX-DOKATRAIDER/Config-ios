//
//  BannerService.swift
//  Core
//
//  Created by Oleg Petrychuk on 03.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public enum BannerServiceError: Error {
    case serverError(Error)
    case noData
}

public protocol BannerService {
    func getBannerForPlayers(forPage page: Int) -> DriverResult<Page<PlayerBanner>, BannerServiceError>
}

public final class BannerServiceImpl: BannerService, ReactiveCompatible {
    private let bannerAPIService: BannerAPIService
    
    public init(bannerAPIService: BannerAPIService) {
        self.bannerAPIService = bannerAPIService
    }

    public func getBannerForPlayers(forPage page: Int) -> DriverResult<Page<PlayerBanner>, BannerServiceError> {
        let request = bannerAPIService.getBannerForPlayers(forPage: page)
        let success = request.success().filter{ $0.content.isNotEmpty }
        let noData = request.success().filter{ $0.content.isEmpty }.map(to: BannerServiceError.noData)
        let serverError = request.failure().map{ BannerServiceError.serverError($0) }
        return Driver.merge(
            success.map{ Result(value: $0) },
            noData.map{ Result(error: $0) },
            serverError.map{ Result(error: $0) }
        )
    }
}
