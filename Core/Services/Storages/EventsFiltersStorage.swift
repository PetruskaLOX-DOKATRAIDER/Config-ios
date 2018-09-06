//
//  EventsFiltersStorage.swift
//  Core
//
//  Created by Oleg Petrychuk on 24.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol EventsFiltersStorage {
    var startDate: BehaviorRelay<Date?> { get }
    var finishDate: BehaviorRelay<Date?> { get }
    var maxCountOfTeams: BehaviorRelay<Int?> { get }
    var minPrizePool: BehaviorRelay<Double?> { get }
}

public final class EventsFiltersStorageImpl: EventsFiltersStorage, ReactiveCompatible {
    enum Keys: String {
        case startDate = "UserStorageImpl.startDate.key"
        case finishDate = "UserStorageImpl.finishDate.key"
        case maxCountOfTeams = "UserStorageImpl.maxCountOfTeams.key"
        case minPrizePool = "UserStorageImpl.minPrizePool.key"
    }
    
    public let startDate: BehaviorRelay<Date?>
    public let finishDate: BehaviorRelay<Date?>
    public let maxCountOfTeams: BehaviorRelay<Int?>
    public let minPrizePool: BehaviorRelay<Double?>
    
    public init(storage: Storage = UserDefaults.standard) {
        startDate = BehaviorRelay(value: (storage.object(forKey: Keys.startDate.rawValue) as? Date?) ?? nil)
        finishDate = BehaviorRelay(value: (storage.object(forKey: Keys.finishDate.rawValue) as? Date?) ?? nil)
        maxCountOfTeams = BehaviorRelay(value: storage.integer(forKey: Keys.maxCountOfTeams.rawValue).zeroIsNil())
        minPrizePool = BehaviorRelay(value: storage.double(forKey: Keys.minPrizePool.rawValue).zeroIsNil())
        
        startDate.asDriver().drive(onNext:{
            storage.set($0, forKey: Keys.startDate.rawValue)
        }).disposed(by: rx.disposeBag)
        finishDate.asDriver().drive(onNext:{
            storage.set($0, forKey: Keys.finishDate.rawValue)
        }).disposed(by: rx.disposeBag)
        maxCountOfTeams.asDriver().map{ $0.value == 0 ? nil : $0 }.drive(onNext:{
            storage.set($0, forKey: Keys.maxCountOfTeams.rawValue)
        }).disposed(by: rx.disposeBag)
        minPrizePool.asDriver().map{ $0.value == 0 ? nil : $0 }.drive(onNext:{
            storage.set($0, forKey: Keys.minPrizePool.rawValue)
        }).disposed(by: rx.disposeBag)
    }
}
