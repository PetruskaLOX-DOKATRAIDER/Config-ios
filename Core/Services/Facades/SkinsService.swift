//
//  SkinsService.swift
//  Core
//
//  Created by Oleg Petrychuk on 23.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public enum SkinsServiceError: Error {
    case serverError(Error)
    case unknown
}

public protocol SkinsService: AutoMockable {
    func subscribeForSkins() -> DriverResult<Skin, SkinsServiceError>
}

public final class SkinsServiceImpl: SkinsService, ReactiveCompatible {
    private let skinsAPIService: SkinsAPIService
    
    public init(skinsAPIService: SkinsAPIService) {
        self.skinsAPIService = skinsAPIService
    }
    
    public func subscribeForSkins() -> DriverResult<Skin, SkinsServiceError> {
        return skinsAPIService.subscribeForNewSkins().map({ result in
            switch result {
            case let .success(skin):
                return Result(value: skin)
            case let .failure(error):
                return Result(error: .serverError(error))
            }
        })
    }
}
