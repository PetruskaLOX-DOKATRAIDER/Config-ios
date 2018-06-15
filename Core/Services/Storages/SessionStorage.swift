//
//  SessionStorage.swift
//  Core
//
//  Created by Oleg Petrychuk on Jun 15, 2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol SessionStorageType: AutoMockable {
    var session: Variable<Session?> { get }
}

open class MemorySessionStorage: SessionStorageType {
    public let session = Variable<Session?>(nil)
    
    public init() {}
}

open class UserDefaultsSessionStorage: SessionStorageType, ReactiveCompatible {
    public let session: Variable<Session?>
    public init(sessionKey: String = "session", defaults: UserDefaults = UserDefaults.standard) {
        self.session = Variable(nil)
        if let currentToken = defaults.string(forKey: "token" + sessionKey) {
            session.value = try? Session(token: currentToken)
        }
        
        self.session.asDriver().drive(onNext: { session in
            print("new token in storage \(session?.token ?? "nil")")
            defaults.set(session?.token, forKey: "token" + sessionKey)
            defaults.synchronize()
        }).disposed(by: rx.disposeBag)
    }
}
