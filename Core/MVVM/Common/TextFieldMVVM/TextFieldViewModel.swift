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

extension TextFieldViewModel {
    public var becomeResponder: PublishSubject<Void> { return .init() }
    public var shouldResign: Driver<Void> { return .empty() }
}

public struct TextFieldViewModelImpl: TextFieldViewModel {
    public let text: BehaviorRelay<String>
    public let placeholder: Driver<String>
}
