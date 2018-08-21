//
//  ProfileEmailItemViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol ProfileEmailItemViewModel {
    var emailVM: TextFieldViewModel { get }
    var selectionTrigger: PublishSubject<Void> { get }
}

public final class ProfileEmailItemViewModelImpl: ProfileEmailItemViewModel {
    public let emailVM: TextFieldViewModel
    public let selectionTrigger = PublishSubject<Void>()
    
    init(userStorage: UserStorage) {
        let text = BehaviorRelay.init(value: "")
        emailVM = TextFieldViewModelImpl(text: text, placeholder: Driver.just(""))
    }
}
