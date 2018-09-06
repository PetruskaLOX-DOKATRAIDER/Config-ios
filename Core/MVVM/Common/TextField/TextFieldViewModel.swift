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

final class TextFieldViewModelImpl: TextFieldViewModel {
    let text: BehaviorRelay<String>
    let placeholder: Driver<String>
    
    init(
        text: BehaviorRelay<String>,
        placeholder: String = ""
    ) {
        self.text = text
        self.placeholder = .just(placeholder)
    }
    
    init(
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
