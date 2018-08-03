//
//  Storage+Teams.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 16.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class TeamsStorageImpl: TeamsStorage, ReactiveCompatible {
    private let coreDataStorage: CoreDataStorage<CDTeam>
    
    public init(coreDataStorage: CoreDataStorage<CDTeam> = CoreDataStorage()) {
        self.coreDataStorage = coreDataStorage
    }
    
    public func update(withNewTeams newTeams: [Team]) -> Driver<Void> {
        return Observable.create{ [weak self] observer -> Disposable in
            self?.coreDataStorage.update(withNewData: newTeams, completion: {
                observer.onNext(())
                //observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: ())
    }
    
    public func fetchTeams() -> Driver<[Team]> {
        return Observable.create{ [weak self] observer -> Disposable in
            self?.coreDataStorage.fetch(completion: { teams in
                observer.onNext(teams)
                //observer.onCompleted()
            })
            return Disposables.create()
        }.asDriver(onErrorJustReturn: [])
    }
}
