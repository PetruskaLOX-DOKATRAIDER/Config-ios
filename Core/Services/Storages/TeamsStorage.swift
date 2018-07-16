//
//  TeamsStorage.swift
//  Core
//
//  Created by Oleg Petrychuk on 16.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol TeamsStorage: AutoMockable {
    func update(withNewTeams newTeams: [Team]) throws
    func fetchTeams() throws -> [Team]
}
