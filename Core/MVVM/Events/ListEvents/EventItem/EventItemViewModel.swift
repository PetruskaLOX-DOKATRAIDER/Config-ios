//
//  EventItemViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol EventItemViewModel {
    var name: Driver<String> { get }
    var city: Driver<String> { get }
    var flagURL: Driver<URL?> { get }
    var logoURL: Driver<URL?> { get }
    var description: Driver<HighlightText> { get }
    var selectionTrigger: PublishSubject<Void> { get }
}

public final class EventItemViewModelImpl: EventItemViewModel, ReactiveCompatible {
    public let name: Driver<String>
    public let city: Driver<String>
    public let flagURL: Driver<URL?>
    public let logoURL: Driver<URL?>
    public let description: Driver<HighlightText>
    public let selectionTrigger = PublishSubject<Void>()
    
    public init(event: Event) {
        name = .just(event.name)
        city = .just(event.city)
        flagURL = .just(event.flagURL)
        logoURL = .just(event.logoURL)
        let startDateStr = DateFormatters.`default`.string(from: event.startDate)
        let finishDateStr = DateFormatters.`default`.string(from: event.finishDate)
        let prizePool = String(event.prizePool) + Strings.ListEvents.currency
        let descriptionhigHlights = [
            String(event.countOfTeams),
            prizePool,
            startDateStr,
            finishDateStr
        ]
        description = .just(HighlightText(
                full: Strings.ListEvents.description(startDateStr, finishDateStr, event.countOfTeams, prizePool),
                highlights: descriptionhigHlights
            )
        )
    }
}
