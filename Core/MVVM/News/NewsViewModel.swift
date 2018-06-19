//
//  NewsViewModel.swift
//  Config
//
//  Created by Oleg Petrychuk on 19.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

// MARK: Protocol

public protocol NewsViewModel {

}

// MARK: Implementation

private final class NewsViewModelImpl: NewsViewModel {

    init() {

    }
}

// MARK: Factory

public class NewsViewModelFactory {
    public static func `default`() -> NewsViewModel {
        return NewsViewModelImpl()
    }
}
