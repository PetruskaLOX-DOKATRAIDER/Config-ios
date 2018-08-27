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

public final class ProfileEmailItemViewModelImpl: ProfileEmailItemViewModel, ReactiveCompatible {
    public let emailVM: TextFieldViewModel
    public let saveTrigger = PublishSubject<Void>()
    
    init(userStorage: UserStorage) {
        emailVM = TextFieldViewModelImpl(text: userStorage.email.value ?? "", placeholder: Strings.Profileemail.placeholder)
        saveTrigger.asDriver(onErrorJustReturn: ()).withLatestFrom(emailVM.text.asDriver()).drive(userStorage.email).disposed(by: rx.disposeBag)
    }
}
