//
//  ProfileEmailItemViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol ProfileEmailItemViewModel: SectionItemViewModelType {
    var emailVM: TextFieldViewModel { get }
    var saveTrigger: PublishSubject<Void> { get }
}

public final class ProfileEmailItemViewModelImpl: ProfileEmailItemViewModel {
    public let emailVM: TextFieldViewModel
    public let saveTrigger = PublishSubject<Void>()
    
    init(userStorage: UserStorage) {
        let email = BehaviorRelay(value: "")
        emailVM = TextFieldViewModelImpl(text: email, placeholder: Strings.Profileemail.placeholder)
    }
}
