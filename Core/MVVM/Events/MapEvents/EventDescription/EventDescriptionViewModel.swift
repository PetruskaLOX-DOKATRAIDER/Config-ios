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
    var shareTrigger: PublishSubject<Void> { get }
    var detailsTrigger: PublishSubject<Void> { get }
    var shouldOpenURL: Driver<URL> { get }
    var shouldShare: Driver<ShareItem> { get }
}

public class EventDescriptionViewModelImpl: EventDescriptionViewModel {
    public let name: Driver<String>
    public let city: Driver<String>
    public let flagURL: Driver<URL?>
    public let logoURL: Driver<URL?>
    public let shareTrigger = PublishSubject<Void>()
    public let detailsTrigger = PublishSubject<Void>()
    public let shouldOpenURL: Driver<URL>
    public let shouldShare: Driver<ShareItem>
    
    public let eventTrigger = PublishRelay<Event>()
    
    public init() {
        name = eventTrigger.asDriver().map{ $0.name }.startWith("")
        city = eventTrigger.asDriver().map{ $0.city }.startWith("")
        flagURL = eventTrigger.asDriver().map{ $0.flagURL }.startWith(nil)
        logoURL = eventTrigger.asDriver().map{ $0.logoURL }.startWith(nil)
        let url = eventTrigger.asDriver().map{ $0.detailsURL }.filterNil()
        shouldOpenURL = detailsTrigger.asDriver(onErrorJustReturn: ()).withLatestFrom(url)
        shouldShare = shareTrigger.asDriver(onErrorJustReturn: ()).withLatestFrom(url).map{ ShareItem(url: $0) }
    }
}
