//
//  PlayersStorage.swift
//  Core
//
//  Created by Oleg Petrychuk on 05.07.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

public protocol PlayersStorage: AutoMockable {
    var playersPreview: BehaviorRelay<[PlayerPreview]> { get }
}