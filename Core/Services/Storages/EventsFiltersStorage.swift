//
//  EventsFiltersStorage.swift
//  Core
//
//  Created by Oleg Petrychuk on 24.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol EventsFiltersStorage: AutoMockable {
    var startDate: BehaviorRelay<Date?> { get }
    var finishDate: BehaviorRelay<Date?> { get }
    var city: BehaviorRelay<String?> { get }
    var maxCountOfTeams: BehaviorRelay<Int> { get }
    var minPrizePool: BehaviorRelay<Double> { get }
}

public final class EventsFiltersStorageImpl: EventsFiltersStorage, ReactiveCompatible {
    enum Keys: String {
        case startDate = "UserStorageImpl.startDate.key"
        case finishDate = "UserStorageImpl.finishDate.key"
        case city = "UserStorageImpl.city.key"
        case maxCountOfTeams = "UserStorageImpl.maxCountOfTeams.key"
        case minPrizePool = "UserStorageImpl.minPrizePool.key"
    }
    
    public let startDate: BehaviorRelay<Date?>
    public let finishDate: BehaviorRelay<Date?>
    public let city: BehaviorRelay<String?>
    public let maxCountOfTeams: BehaviorRelay<Int>
    public let minPrizePool: BehaviorRelay<Double>
    
    public init(storage: Storage = UserDefaults.standard) {
        startDate = BehaviorRelay(value: (storage.object(forKey: Keys.startDate.rawValue) as? Date?) ?? nil)
        finishDate = BehaviorRelay(value: (storage.object(forKey: Keys.finishDate.rawValue) as? Date?) ?? nil)
        city = BehaviorRelay(value: storage.string(forKey: Keys.city.rawValue))
        maxCountOfTeams = BehaviorRelay(value: storage.integer(forKey: Keys.maxCountOfTeams.rawValue))
        minPrizePool = BehaviorRelay(value: storage.double(forKey: Keys.minPrizePool.rawValue))
        
        startDate.asDriver().drive(onNext: { storage.set($0, forKey: Keys.startDate.rawValue) }).disposed(by: rx.disposeBag)
        finishDate.asDriver().drive(onNext: { storage.set($0, forKey: Keys.finishDate.rawValue) }).disposed(by: rx.disposeBag)
        city.asDriver().drive(onNext: { storage.set($0, forKey: Keys.city.rawValue) }).disposed(by: rx.disposeBag)
        maxCountOfTeams.asDriver().drive(onNext: { storage.set($0, forKey: Keys.maxCountOfTeams.rawValue) }).disposed(by: rx.disposeBag)
        minPrizePool.asDriver().drive(onNext: { storage.set($0, forKey: Keys.minPrizePool.rawValue) }).disposed(by: rx.disposeBag)
    }
}
