//
//  TextFieldViewModel.swift
//  Core
//
//  Created by Петрічук Олег Аркадійовіч on 21.03.18.
//  Copyright © 2018 MLSDev. All rights reserved.
//

public protocol TextFieldViewModel {
    var text: BehaviorRelay<String> { get }
    var placeholder: Driver<String> { get }
    var becomeResponder: PublishSubject<Void> { get }
    var shouldResign: Driver<Void> { get }
}

public final class TextFieldViewModelImpl: TextFieldViewModel {
    public let text: BehaviorRelay<String>
    public let placeholder: Driver<String>
    
    public init(
        text: BehaviorRelay<String>,
        placeholder: String = ""
    ) {
        self.text = text
        self.placeholder = .just(placeholder)
    }
    
    public init(
        text: String = "",
        placeholder: String = ""
    ) {
        self.text = BehaviorRelay(value: text)
        self.placeholder = .just(placeholder)
    }
}

extension TextFieldViewModel {
    public var becomeResponder: PublishSubject<Void> {
        return .init()
    }
    
    public var shouldResign: Driver<Void> {
        return .empty()
    }
}
