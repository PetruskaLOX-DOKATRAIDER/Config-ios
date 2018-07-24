//
//  EventDescriptionViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 24.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol EventDescriptionViewModel {
    var name: Driver<String> { get }
    var city: Driver<String> { get }
    var flagURL: Driver<URL?> { get }
    var logoURL: Driver<URL?> { get }
    var shareTrigger: PublishRelay<Void> { get }
    var detailsTrigger: PublishRelay<Void> { get }
}

public class EventDescriptionViewModelImpl: EventDescriptionViewModel {
    public let name: Driver<String>
    public let city: Driver<String>
    public let flagURL: Driver<URL?>
    public let logoURL: Driver<URL?>
    public let shareTrigger = PublishRelay<Void>()
    public let detailsTrigger = PublishRelay<Void>()
    
    public let eventTrigger = PublishRelay<Event>()
    
    public init() {
        name = eventTrigger.asDriver().map{ $0.name }.startWith("")
        city = eventTrigger.asDriver().map{ $0.city }.startWith("")
        flagURL = eventTrigger.asDriver().map{ $0.flagURL }.startWith(nil)
        logoURL = eventTrigger.asDriver().map{ $0.logoURL }.startWith(nil)
    }
}
