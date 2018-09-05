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
public protocol WebsocketService {
    func connect(withURL url: URL, connectMessage: String?) -> DriverResult<ReceivedMessage, WebsocketServiceError>
}

public final class WebsocketServiceImpl: WebsocketService {
    private let socket: WebSocket
    
    public init(socket: WebSocket = WebSocket(url: URL(fileURLWithPath: ""))) {
        self.socket = socket
    }
    
    public func connect(withURL url: URL, connectMessage: String?) -> DriverResult<ReceivedMessage, WebsocketServiceError> {
        return Observable.create({ [weak self] observer -> Disposable in
            self?.socket.request.url = url
            if let message = connectMessage {
                self?.socket.onConnect = { self?.socket.write(string: message) }
            }
            self?.socket.onDisconnect = {
                observer.onNext(Result(error: WebsocketServiceError.disconnect($0)))
                observer.onCompleted()
            }
            self?.socket.onText = {
                observer.onNext(Result(value: $0))
            }
            self?.socket.connect()
            return Disposables.create()
        }).asDriver(onErrorJustReturn: Result(error: WebsocketServiceError.unknown))
    }
}
