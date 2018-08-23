//
//  WebsocketService.swift
//  Core
//
//  Created by Oleg Petrychuk on 23.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Starscream

public enum WebsocketServiceError: Error {
    case disconnect(Error?)
    case unknown
}

public typealias ReceivedMessage = String
public protocol WebsocketService: AutoMockable {
    func connect(withURL url: URL, connectMessage: String?) -> DriverResult<ReceivedMessage, WebsocketServiceError>
}

public class WebsocketServiceImpl: WebsocketService {
    
    public init() {}
    
    public func connect(withURL url: URL, connectMessage: String?) -> DriverResult<ReceivedMessage, WebsocketServiceError> {
        return Observable.create({ observer -> Disposable in
            let socket = WebSocket(url: url)
            if let message = connectMessage {
                socket.onConnect = { socket.write(string: message) }
            }
            socket.onDisconnect = {
                observer.onNext(Result(error: WebsocketServiceError.disconnect($0)))
                //observer.onCompleted()
            }
            socket.onText = {
                observer.onNext(Result(value: $0))
                //observer.onCompleted()
            }

            socket.connect()
            return Disposables.create()
        }).asDriver(onErrorJustReturn: Result(error: WebsocketServiceError.unknown))
    }
}
