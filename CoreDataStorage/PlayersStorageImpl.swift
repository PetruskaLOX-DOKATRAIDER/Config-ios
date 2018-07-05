//
//  PlayersStorageImpl.swift
//  CoreDataStorage
//
//  Created by Oleg Petrychuk on 05.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import Core
import CoreData

public class PlayersStorageImpl: PlayersStorage, ReactiveCompatible {
    public let playersPreview: BehaviorRelay<[PlayerPreview]> = BehaviorRelay(value: [])
    
    public init(coreDataStack: CoreDataStack = CoreDataStack()) {
        coreDataStack.privateContext.perform {
            let request: NSFetchRequest = CDPlayerPreview.fetchRequest()
            let players = try? coreDataStack.privateContext.fetch(request).map{ PlayerPreview.new(player: $0) }
            players >>- self.playersPreview.accept
        }
        
        playersPreview.asDriver().drive(onNext: { players in
            coreDataStack.privateContext.perform {
                _ = players.map{ CDPlayerPreview.new(conext: coreDataStack.privateContext, player: $0) }
                try? coreDataStack.privateContext.save()
            }
        }).disposed(by: rx.disposeBag)
    }
}

