//
//  SectionSubtopicViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 22.08.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

protocol SectionSubtopicViewModel: SectionSubtopicViewModelType {
    var message: Driver<String> { get }
}

public struct SectionSubtopicViewModelImpl: SectionSubtopicViewModel, ReactiveCompatible {
    public let message: Driver<String>
    
    public init(message: String = "") {
        self.message = .just(message)
    }
}
