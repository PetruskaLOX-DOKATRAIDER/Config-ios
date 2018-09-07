//
//  TeamsStorage.swift
//  Core
//
//  Created by Oleg Petrychuk on 16.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol TeamsStorage {
    func update(withNew teams: [Team]) -> Driver<Void>
    func get() -> Driver<[Team]>
}
