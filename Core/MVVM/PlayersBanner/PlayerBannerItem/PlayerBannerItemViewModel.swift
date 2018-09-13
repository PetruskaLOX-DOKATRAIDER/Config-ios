//
//  PlayerBannerItemViewModel.swift
//  Core
//
//  Created by Oleg Petrychuk on 16.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol PlayerBannerItemViewModel {
    var coverImageURL: Driver<URL?> { get }
    var title: Driver<String> { get }
    var selectionTrigger: PublishSubject<Void> { get }
}

public final class PlayerBannerItemViewModelImpl: PlayerBannerItemViewModel, ReactiveCompatible {
    public let coverImageURL: Driver<URL?>
    public let title: Driver<String>
    public let selectionTrigger = PublishSubject<Void>()
    private let playerBanner: PlayerBanner
    
    public init(playerBanner: PlayerBanner) {
        self.playerBanner = playerBanner
        func getTitle(withDate date: Date) -> String {
            switch date.daysBetweenDate(Date()) ?? 0 {
            case 0, 1: return Strings.PlayerBanner.updatedToday
            case 2: return Strings.PlayerBanner.updatedYesterday
            case 3...30: return Strings.PlayerBanner.updatedPrefix + " " + DateFormatters.`default`.string(from: date)
            default: return Strings.PlayerBanner.updatedLongTime
            }
        }
    
        coverImageURL = .just(playerBanner.coverImageURL)
        title = .just(getTitle(withDate: playerBanner.updatedDate))
    }
}
