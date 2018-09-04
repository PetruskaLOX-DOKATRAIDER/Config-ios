//
//  TeamsStorageImpl.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 04.09.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public final class TeamsStorageImpl: TeamsStorage, ReactiveCompatible {
    private let teamObjectStorage: CDObjectableStorage<CDTeam>
    
    public init(teamObjectStorage: CDObjectableStorage<CDTeam> = CDObjectableStorage()) {
        self.teamObjectStorage = teamObjectStorage
    }
    
    public func update(withNewTeams newTeams: [Team]) -> Driver<Void> {
        return Observable.create{ [weak self] observer -> Disposable in
            observer.onNext(())
            self?.teamObjectStorage.update(withNewData: newTeams, completion: {
                observer.onNext(())
                observer.onCompleted()
            })
            return Disposables.create()
            }.asDriver(onErrorJustReturn: ())
    }
    
    public func fetchTeams() -> Driver<[Team]> {
        return Observable.create{ [weak self] observer -> Disposable in
            self?.teamObjectStorage.fetch(completion: { teams in
                observer.onNext(teams)
                observer.onCompleted()
            })
            return Disposables.create()
            }.asDriver(onErrorJustReturn: [])
    }
}
