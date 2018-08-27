//
//  SkinsAPIService.swift
//  Core
//
//  Created by Oleg Petrychuk on 23.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public enum SkinsAPIServiceError: Error {
    case serverError(Error)
    case invalidResponse
    case unknown
}

public protocol SkinsAPIService: AutoMockable {
    func subscribeForNewSkins() -> DriverResult<Skin, SkinsAPIServiceError>
}

public class SkinsAPIServiceImpl: SkinsAPIService {
    private let appEnvironment: AppEnvironment
    private let websocketService: WebsocketService

    public init(
        appEnvironment: AppEnvironment,
        websocketService: WebsocketService
    ) {
        self.appEnvironment = appEnvironment
        self.websocketService = websocketService
    }
    
    public func subscribeForNewSkins() -> DriverResult<Skin, SkinsAPIServiceError> {
        let connect = websocketService.connect(withURL: appEnvironment.skinsApiURL, connectMessage: "history_go")
        return connect.map { result in
            switch result {
            case let .success(receivedMessage):
                var message = receivedMessage.applyingTransform(StringTransform("Any-Hex/Java"), reverse: true)
                message = message?.replacingOccurrences(of: "\"", with: "")
                message = message?.replacingOccurrences(of: "\\", with: "")
                guard let response = message else { return Result(error: .invalidResponse) }
                guard let skin = try? Skin(response: response, coverImageApiURL: self.appEnvironment.skinsCoverImageApiURL) else { return Result(error: .invalidResponse) }
                return Result(value: skin)
            case let .failure(error):
                return Result(error: .serverError(error))
            }
        }
    }
}
